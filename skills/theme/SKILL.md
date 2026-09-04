---
name: theme
description: Explains and changes this app’s light/dark theme, default theme, colors, ThemeExtensions, and fonts. Use when the user mentions theme, dark mode, light mode, colors, ThemeExtension, fonts, Google Fonts, MyTheme, or MyStyles.
---

# Theme

Light and dark palettes live in color classes. `MyTheme.getThemeData` builds `ThemeData`. The current mode is stored in shared preferences (default light). Fonts follow the current language family.

## How it works

`GetMaterialApp` wraps the tree with `Theme(data: MyTheme.getThemeData(isLight: MySharedPref.getThemeIsLight()))`.

Toggle (persists, then GetX updates the mode):

```dart
MyTheme.changeTheme();
```

Read current mode (true = light):

```dart
bool themeIsLight = MySharedPref.getThemeIsLight();
```

`changeTheme` implementation:

```dart
static changeTheme() {
  bool isLightTheme = MySharedPref.getThemeIsLight();
  MySharedPref.setThemeIsLight(!isLightTheme);
  Get.changeThemeMode(!isLightTheme ? ThemeMode.light : ThemeMode.dark);
}
```

Shared-pref default (this is the **default theme**):

```dart
static bool getThemeIsLight() =>
    _sharedPreferences.getBool(_lightThemeKey) ?? true; // true = light, false = dark
```

Palette files hold colors. `MyStyles` maps those colors onto `AppBarTheme`, `TextTheme`, buttons, chips, list tiles, and custom `ThemeExtension`s. `MyFonts` holds sizes (already `.sp`) and the active `fontFamily`.

Read colors from `Theme.of(context)` in widgets (`primaryColor`, `colorScheme`, `textTheme`, `extension<...>()`). Edit palettes, not widget files, when the user wants a new brand color.

## Change theme (runtime)

Add a control that calls `MyTheme.changeTheme()`. No other files.

## Change default theme

In the shared-pref theme getter, set the fallback:

- light default: `?? true`
- dark default: `?? false`

Done when that fallback matches what the user asked.

## Colors

Edit both palettes so light and dark stay in sync. Typical slots: `primaryColor`, `accentColor`, `scaffoldBackgroundColor`, `appBarColor` / `appbarColor`, `bodyTextColor`, `buttonColor`, and any extension colors at the bottom of each palette class.

`MyTheme.getThemeData` already wires `primaryColor`, `colorScheme`, `scaffoldBackgroundColor`, `cardColor`, `appBarTheme`, `textTheme`, `extensions`, etc. After palette edits, existing widgets that read `Theme.of(context)` pick up the new colors.

## Add a ThemeExtension

Use this when the user needs widget-specific colors/styles that do not belong on global `ThemeData`.

**1. Extension class** at `lib/config/theme/theme_extensions/{snake}_theme_data.dart`:

```dart
import 'package:flutter/material.dart';

class {pascal}ThemeData extends ThemeExtension<{pascal}ThemeData> {
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;

  const {pascal}ThemeData({
    this.backgroundColor,
    this.titleTextStyle,
  });

  @override
  ThemeExtension<{pascal}ThemeData> copyWith({
    Color? backgroundColor,
    TextStyle? titleTextStyle,
  }) {
    return {pascal}ThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    );
  }

  @override
  {pascal}ThemeData lerp(ThemeExtension<{pascal}ThemeData>? other, double t) {
    if (other is! {pascal}ThemeData) return this;
    return {pascal}ThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
    );
  }
}
```

Add or remove fields to match the request. Keep `copyWith` and `lerp` in sync with those fields.

**2. Colors** on both palettes:

```dart
static const Color {name}BackgroundColor = Color(0xFF......);
```

**3. Factory on `MyStyles`:**

```dart
static {pascal}ThemeData get{pascal}Theme({required bool isLightTheme}) {
  return {pascal}ThemeData(
    backgroundColor: isLightTheme
        ? LightThemeColors.{name}BackgroundColor
        : DarkThemeColors.{name}BackgroundColor,
    titleTextStyle: MyFonts.bodyTextStyle.copyWith(
      fontSize: MyFonts.bodyMediumSize,
      color: isLightTheme
          ? LightThemeColors.bodyTextColor
          : DarkThemeColors.bodyTextColor,
    ),
  );
}
```

**4. Register** in `MyTheme.getThemeData` `extensions:` list:

```dart
extensions: [
  MyStyles.getHeaderContainerTheme(isLightTheme: isLight),
  MyStyles.getEmployeeListItemTheme(isLightTheme: isLight),
  MyStyles.get{pascal}Theme(isLightTheme: isLight),
]
```

**5. Consume:**

```dart
final ext = Theme.of(context).extension<{pascal}ThemeData>();
Container(color: ext?.backgroundColor);
```

Done when the class exists, both palettes have the colors, `MyStyles` builds it, and `MyTheme.extensions` includes it.

## Fonts

Font family is per language:

```dart
static Map<String, TextStyle> supportedLanguagesFontsFamilies = {
  'en': const TextStyle(fontFamily: 'Poppins'),
  'ar': const TextStyle(fontFamily: 'Cairo'),
};
```

`MyFonts.getAppFontType` reads that map from the current locale, and text themes copy it.

### Change fonts

1. Ask which language(s) and which family (and weights if given). Default weights to register: Regular, Medium, SemiBold.
2. Look in `assets/fonts/` and under `flutter: fonts:` in `pubspec.yaml` for that family.
3. **Files already there** → skip download. Register the family in `pubspec.yaml` if missing, then set `fontFamily` in `supportedLanguagesFontsFamilies` for those language codes.
4. **Files missing** → ask: download from Google Fonts, or will the user add the files? Do not download until they confirm.
5. **User declines download** → stop the font change. Tell them to put `.ttf` / `.otf` files in `assets/fonts/` first, then ask again.
6. **User confirms download** → fetch the family from Google Fonts (GitHub `google/fonts` or `https://fonts.google.com/download?family={Family+Name}`), unzip, copy the requested weights into `assets/fonts/` using names like `{Family}-Regular.ttf`. Then register and switch the family map.

`pubspec.yaml` font block (same shape as existing families):

```yaml
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
          weight: 300
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 700
    - family: {Family}
      fonts:
        - asset: assets/fonts/{Family}-Regular.ttf
          weight: 400
        - asset: assets/fonts/{Family}-Medium.ttf
          weight: 500
        - asset: assets/fonts/{Family}-SemiBold.ttf
          weight: 700
```

Keep `assets/fonts/` listed under `flutter: assets:`.

Font sizes stay on `MyFonts` with `.sp` (example: `18.sp`). Change those numbers when the user asks for type scale, not by hardcoding `fontSize: 18` in widgets.

Done when the files are on disk, `pubspec.yaml` lists the family, and `supportedLanguagesFontsFamilies` uses that family name.
