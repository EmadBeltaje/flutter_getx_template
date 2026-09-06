# Architecture

This is a **GetX-pattern** Flutter app (state management, navigation, and DI all via `package:get`). One architecture is used throughout — do not introduce a second one (no Provider/Riverpod/Bloc, no `lib/presentation`, no other router).

## Tech stack

| Concern | Package |
|---|---|
| State mgmt / navigation / DI | `get` |
| Responsive sizing | `flutter_screenutil` |
| HTTP | `dio` (wrapped by `BaseClient`) |
| Structured local storage | `hive` / `hive_flutter` |
| Key-value local storage | `shared_preferences` |
| Push notifications | `firebase_messaging` + `awesome_notifications` |
| Vectors | `flutter_svg` |
| Logging | `logger` |

## Folder layout

```
lib
├── app
│   ├── components      # shared/reusable widgets (not screen-specific)
│   ├── data
│   │   ├── local        # MyHive, MySharedPref — the only two local-storage entry points
│   │   └── models       # data models (raw or Hive, see below)
│   ├── modules           # one folder per screen/feature — the actual app
│   ├── routes            # get_cli-style generated routes (app_pages.dart / app_routes.dart)
│   └── services           # networking layer: BaseClient, ApiException, ApiCallStatus
├── config
│   ├── theme              # color palettes, MyStyles, MyTheme, ThemeExtensions
│   └── translations        # Strings keys, per-language maps, LocalizationService
└── utils                    # helpers that don't fit elsewhere (Constants, FcmHelper, notifications)
```

Every screen lives under `lib/app/modules/{feature}/` with three sibling folders: `bindings/`, `controllers/`, `views/` (optionally `views/widgets/` for screen-local widgets). This triple is never split across other folders, and a feature's business logic never leaks into `app/components` (that folder is for widgets shared across features).

Nested screens (a screen that only makes sense inside another) live at `lib/app/modules/{parent}/{child}/` with the same three subfolders, and their route is a child `GetPage` of the parent's route — not a new top-level route.

## App bootstrap (`main.dart`)

Startup order matters and mirrors dependency order — don't reorder without a reason:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `MyHive.init(...)` — registers Hive adapters (e.g. `UserModelAdapter`) before anything reads from Hive
3. `MySharedPref.init()`
4. `FcmHelper.initFcm()`
5. `AwesomeNotificationsHelper.init()`
6. `ScreenUtilInit` wraps `GetMaterialApp`, which reads theme (`MySharedPref.getThemeIsLight()`) and locale (`MySharedPref.getCurrentLocal()`) at build time, and wires `AppPages.routes` / `AppPages.initial`.

New app-level singletons/services that need to exist before the first screen renders are initialized here, in this same sequence style (init the store, then anything that reads from it).

## Navigation & DI (routes + bindings)

- `app_pages.dart` / `app_routes.dart` follow the `get_cli` generated shape (`Routes` / `_Paths`, `GetPage` list). Treat them as generated-style files: additive, consistent identifier casing (lowercase, matching `home`).
- Every module has a `{Feature}Binding` that registers its controller(s) with `Get.lazyPut`. A screen is never pushed without a binding that provides its controller — that's how the view's `GetView<Controller>` resolves `controller`.
- A controller does not construct itself inside a view; it's always resolved via `Get.lazyPut` in a binding.

## State management shape

Screens that show API-driven data use **plain fields + `apiCallStatus` + `update()`**, read in the view through `GetBuilder<{Feature}Controller>` (see `coding-guideline.md` / `skills/api-request`, `skills/ui-conventions`). This is the dominant pattern in this codebase — prefer it for anything backed by `BaseClient`.

The scaffold controller template (from `create-screen`/`create-controller`) starts with a `.obs` counter purely as a placeholder; that's not a signal to use reactive (`Obx`/`.obs`) state for feature logic. Reserve `.obs`/`GetX`/`Obx` for small, purely-local UI state where `update()` would be overkill — don't mix both patterns for the same piece of state on one controller.

## Networking layer

`lib/app/services/`:

- `base_client.dart` — `BaseClient.safeApiCall(url, RequestType, onLoading, onSuccess, onError, ...)` wraps Dio, converts every failure mode (Dio error, socket, timeout, unexpected) into an `ApiException`, and auto-shows an error toast when `onError` is omitted.
- `api_call_status.dart` — `ApiCallStatus` enum (`holding, loading, success, error, empty, cache, refresh`) is the single source of truth the UI switches on via `MyWidgetsAnimator`.
- `api_exceptions.dart` — `ApiException` carries a user-presentable `toString()`, preferring an API-supplied message over the raw Dio message.

All network calls go through `BaseClient`; a controller never talks to `Dio` directly.

## Data layer

`lib/app/data/models/` holds two kinds of models:

- **Raw models** (default): plain `fromJson`/`toJson` classes, no Hive annotations. This is what new API models should be unless Hive persistence is explicitly requested.
- **Hive models** (opt-in, e.g. `UserModel`): `@HiveType`/`@HiveField`, generated `.g.dart` part file, unique `typeId`, and a required empty constructor so Hive can deserialize it. New Hive adapters must be registered in `main.dart`'s `MyHive.init(registerAdapters: ...)`.

`lib/app/data/local/` has exactly two stores, and each has one job:

- `MyHive` — structured entities (currently the logged-in `UserModel`), boxed by name.
- `MySharedPref` — small key/value settings: theme flag, current locale, FCM token. Not for structured/collection data.

## Theming architecture

`light_theme_colors.dart` / `dark_theme_colors.dart` (palettes) → `my_styles.dart` (maps palette colors onto `ThemeData` slots and any `ThemeExtension`s) → `my_theme.dart` (`MyTheme.getThemeData(isLight)` assembles the final `ThemeData`). Current mode is persisted in `MySharedPref` (default light) and toggled via `MyTheme.changeTheme()`. Widgets read colors from `Theme.of(context)` / `.extension<...>()` — never from a palette class directly.

## Localization architecture

`strings_enum.dart` (`Strings` keys) → one map per language (`en_us_translation.dart`, `ar_ar_translation.dart`, ...) → `localization_service.dart` (`LocalizationService extends Translations`, `supportedLanguages`, `defaultLanguage`, `supportedLanguagesFontsFamilies`). Current locale is persisted in `MySharedPref`. Every `Strings.*` key must have an entry in every language map — a language file missing a key is a bug, not a fallback case.

## Notifications

`utils/fcm_helper.dart` initializes Firebase Messaging and exposes the hook for sending the FCM token to your backend. `utils/awesome_notifications_helper.dart` handles local/foreground notification presentation. Both are initialized once in `main.dart` and are not re-initialized per screen.

## Testing

- `test/` — unit tests for the services layer (`BaseClient`, `MyHive`, `MySharedPref`, `LocalizationService`), using `mockito`/`http_mock_adapter`.
- `integration_test/` — widget/behavior-level tests (`BaseClient`, `AwesomeNotificationsHelper`, `MyWidgetsAnimator`).

New services-layer code gets a unit test alongside the existing ones; new cross-widget behavior gets an integration test alongside the existing ones.