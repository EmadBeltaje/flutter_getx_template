# Coding Guideline

`architecture.md` says **where** things go. This file says **how** to write them so new code reads like it was written by the same person who wrote the rest of this app. When a task-specific `skills/*` file applies, follow it — it wins on the specifics of that task; this file covers everything else and the cross-cutting rules.

## Naming & file layout

| Thing | Rule | Example |
|---|---|---|
| File names | `snake_case.dart` | `home_controller.dart` |
| Class names | `PascalCase` | `HomeController` |
| Controller | `{Feature}Controller`, file `{feature}_controller.dart` | `LoginController` |
| View | `{Feature}View`, file `{feature}_view.dart` | `LoginView` |
| Binding | `{Feature}Binding`, file `{feature}_binding.dart` | `LoginBinding` |
| Model | `{Name}Model`, file `{name}_model.dart` | `TodoModel` |
| ThemeExtension | `{Name}ThemeData`, file `{name}_theme_data.dart` | `HeaderContainerThemeData` |

Imports inside `lib/` are **relative** (`../../services/base_client.dart`), matching the rest of the codebase — not `package:getx_skeleton/...` absolute imports. External packages use normal `package:` imports.

## State management

- Default to plain fields + `ApiCallStatus` + `update()`, read via `GetBuilder<{Feature}Controller>`. This is the established pattern for anything backed by an API call — don't switch to `.obs`/`Obx` for it.
- `.obs`/`GetX`/`Obx` is acceptable only for small, purely local UI state (a toggle, a counter) where there's no `apiCallStatus` involved. Don't mix the two patterns for the same piece of state within one controller.
- A controller never talks to `Dio` directly and never builds its own instance — it's provided by its module's `Binding` via `Get.lazyPut`.
- Views stay thin: no business logic, no direct API calls in a `build()` method. If a view needs a computed value or a decision, that belongs on the controller.

## UI rules (every widget/screen you write or touch)

- **Sizes**: always `.w` / `.h` / `.sp` / `.r` / `.verticalSpace` / `.horizontalSpace` — never a raw `double` for layout dimensions. (`double.infinity` and unit factors like a `1.0` border width are fine as-is.)
- **Copy**: every user-visible string goes through `Strings.{key}.tr`. If the key doesn't exist yet, add it to `Strings` **and** to every language map in the same change — a key missing from one language is a bug.
- **Color**: read from `Theme.of(context)` or a `ThemeExtension`. Never a literal `Color(0xFF...)` or a `Colors.*` constant inside a widget — new brand colors go on the light/dark palette classes first.
- **API-bound regions**: wrap in `GetBuilder` + `MyWidgetsAnimator`, driven by `controller.apiCallStatus`. Don't hand-roll `if (loading) ... else if (error) ...` UI switching.
- **Snackbars/toasts**: use `CustomSnackBar.showCustomSnackBar` / `showCustomErrorSnackBar` / `showCustomToast` / `showCustomErrorToast` — not `ScaffoldMessenger` or a third-party toast package directly.
- Split a screen's UI into `views/widgets/{name}.dart` once a section of the view stops being trivial (mirrors `header.dart`, `data_grid.dart`, `employees_list.dart` in `home`). Keep the top-level view file readable as an outline of the screen, not a wall of nested widgets.

## Networking & models

- Every request goes through `BaseClient.safeApiCall` (or `BaseClient.download` for files). Never call `Dio` directly from a controller.
- Always set `apiCallStatus = ApiCallStatus.loading` / `.success` / `.error` and call `update()` in `onLoading` / `onSuccess` / `onError` — even when you also pass a custom `onError`, still set `.error` there so the UI can react. Don't leave a call without wiring `apiCallStatus`.
- New API URLs are constants on `Constants` (`static const {name}ApiUrl = ...`), never inline string literals at the call site.
- New models default to raw `fromJson`/`toJson`. Only add `@HiveType`/`@HiveField` + a `.g.dart` part + a registered adapter when persistence was actually asked for — `UserModel` is the one deliberate exception, not the template.
- When `onError` is omitted, `BaseClient` already shows an error toast from `ApiException.toString()` — don't add a second, redundant error UI on top of that.

## Local storage

- `MySharedPref` for small settings/flags/tokens (theme, locale, FCM token) — one key, one getter/setter pair, following the existing `_xKey` constant + typed getter/setter shape.
- `MyHive` for structured/persisted entities. Don't reach for Hive for something that's really just a flag or a string — that's a `SharedPreferences` key.

## Comments & structure

- Keep the existing terse, purposeful comment style (`// 1) indicate loading state`, `// ----------------------- Header ----------------------- //` section dividers in longer views). Comments explain *why* or label a section, not restate the line below them.
- Use `// TODO` for anything intentionally left for the user to fill in (matches `Constants`, `ApiException`, `main.dart`), not a bare unmarked stub.

## Don't

- Don't introduce a second state-management or navigation package (Provider, Riverpod, Bloc, go_router, ...). This project is GetX end to end.
- Don't create `lib/presentation` or any parallel folder structure — screens live under `lib/app/modules` and nowhere else.
- Don't copy an existing feature's controller/view/widget as a "starting template" for a new one — those files carry feature-specific logic. Start from the clean templates in `skills/create-screen` / `skills/create-controller` instead.
- Don't hardcode strings, colors, or pixel sizes "just for now" — add the key/color/ScreenUtil value properly even in a first draft; it's the same amount of work and avoids a cleanup pass later.
- Don't bypass `BaseClient` for a "quick" request, and don't swallow an error silently (always land on an `ApiCallStatus` and either the default error toast or an explicit error widget).

## Linting & tests

- `analysis_options.yaml` uses `package:flutter_lints/flutter.yaml` as-is — don't disable a rule to make new code pass; fix the code instead, unless the user explicitly asks to change lint rules.
- New service-layer logic (anything under `lib/app/services` or `lib/app/data/local`) gets a unit test under `test/`, following the existing `BaseClient`/`MyHive`/`MySharedPref` test shape (`mockito` / `http_mock_adapter`).
- New cross-widget behavior (a new animator, a new plugin wrapper) gets an integration test under `integration_test/`, following the existing shape.