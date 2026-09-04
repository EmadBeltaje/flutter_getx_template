---
name: ui-conventions
description: UI rules for creating or editing widgets and screens in this app: ScreenUtil sizes, localized strings, theme colors, MyWidgetsAnimator for API UI, and CustomSnackBar. Use when writing or changing Flutter UI, widgets, screens, views, snackbars, or toasts.
---

# UI conventions

Apply these rules to every widget or screen being created or edited. They keep layout, copy, color, API states, and toasts consistent with the rest of the app.

## Sizes — ScreenUtil

Use ScreenUtil extensions, not raw doubles, for layout:

```dart
200.w   // width
100.h   // height
25.sp   // font size
10.r    // radius
10.verticalSpace
9.horizontalSpace
```

```dart
Container(
  height: 100.h,
  width: 200.w,
  padding: EdgeInsets.symmetric(horizontal: 20.w),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
  ),
  child: Text(
    Strings.hello.tr,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20.sp),
  ),
)
```

`double.infinity` and `1.0` (as a factor, e.g. border width 1) are fine. Design sizes belong on `.w` / `.h` / `.sp` / `.r`.

## Strings — localization

User-visible copy goes through `Strings.{key}.tr`. If the key does not exist yet, add it to `Strings` and every language map.

```dart
Text(Strings.hello.tr)
```

## Colors — theme

Read color from `Theme.of(context)` or a `ThemeExtension`. Brand colors belong in the light/dark palettes (theme skill), not as `Color(0xFF...)` or `Colors.red` in widgets.

```dart
final theme = Theme.of(context);
Container(color: theme.primaryColor);
Text('...', style: theme.textTheme.bodyMedium);

final itemTheme = theme.extension<EmployeeListItemThemeData>();
Container(color: itemTheme?.backgroundColor);
```

## API UI — MyWidgetsAnimator

When the screen shows data from an API call, wrap that region in `GetBuilder` + `MyWidgetsAnimator` driven by the controller’s `apiCallStatus`.

```dart
GetBuilder<{pascal}Controller>(
  builder: (_) {
    return MyWidgetsAnimator(
      apiCallStatus: controller.apiCallStatus,
      loadingWidget: () => const Center(child: CircularProgressIndicator()),
      errorWidget: () => ApiErrorWidget(
        message: Strings.internetError.tr,
        retryAction: () => controller.{method}(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
      ),
      successWidget: () => ListView.separated(
        itemCount: controller.data!.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (ctx, index) => ListTile(
          title: Text(controller.data![index].title),
        ),
      ),
    );
  },
)
```

Pass `emptyWidget` when an empty list needs its own state. Optional slots: `holdingWidget`, `refreshWidget`.

`ApiErrorWidget`:

```dart
class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({
    super.key,
    required this.message,
    required this.retryAction,
    this.padding,
  });

  final String message;
  final Function retryAction;
  final EdgeInsets? padding;
}
```

## Snackbars / toasts — CustomSnackBar

```dart
CustomSnackBar.showCustomSnackBar(
  title: Strings.hello.tr,
  message: Strings.hello.tr,
);
CustomSnackBar.showCustomErrorSnackBar(
  title: Strings.someThingWentWorng.tr,
  message: Strings.internetError.tr,
);
CustomSnackBar.showCustomToast(message: Strings.hello.tr);
CustomSnackBar.showCustomErrorToast(message: Strings.internetError.tr);
```

Titles and messages still use `Strings.*.tr`.

## Done

New or edited UI uses ScreenUtil for sizes, `Strings.*.tr` for copy, theme for color, `MyWidgetsAnimator` around API-bound regions, and `CustomSnackBar` for snackbars/toasts.
