---
name: localization
description: Explains and changes GetX localization in this app: default language, switching language, adding a language, and adding string keys. Use when the user mentions localization, translation, locale, language, Strings.tr, i18n, or LocalizationService.
---

# Localization

GetX `Translations` with keys in `Strings`, and one map file per language. Current locale is stored in shared preferences.

## How it works

`GetMaterialApp` uses:

```dart
locale: MySharedPref.getCurrentLocal(),
translations: LocalizationService.getInstance(),
```

Service shape:

```dart
class LocalizationService extends Translations {
  static Locale defaultLanguage = supportedLanguages['en']!;

  static Map<String, Locale> supportedLanguages = {
    'en': const Locale('en', 'US'),
    'ar': const Locale('ar', 'AR'),
  };

  static Map<String, TextStyle> supportedLanguagesFontsFamilies = {
    'en': const TextStyle(fontFamily: 'Poppins'),
    'ar': const TextStyle(fontFamily: 'Cairo'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'ar_AR': arAR,
  };
}
```

Keys:

```dart
class Strings {
  static const String hello = 'hello';
}
```

Per-language maps (every `Strings.*` key must appear in every map):

```dart
const Map<String, String> enUs = {
  Strings.hello: 'Hello!',
};

final Map<String, String> arAR = {
  Strings.hello: 'مرحباً!',
};
```

In widgets:

```dart
Text(Strings.hello.tr)
```

Switch language:

```dart
LocalizationService.updateLanguage('en'); // or 'ar'
```

`updateLanguage` checks `supportedLanguages`, writes shared pref, then `Get.updateLocale`.

Read locale:

```dart
LocalizationService.getCurrentLocal();
// or
MySharedPref.getCurrentLocal();
```

If shared pref has no value, it returns `LocalizationService.defaultLanguage`.

## Change default language

Set:

```dart
static Locale defaultLanguage = supportedLanguages['en']!;
```

to the supported code the user wants (`'ar'`, `'fr'`, …). That code must already exist in `supportedLanguages`. If it does not, add the language first.

Done when `defaultLanguage` points at the requested supported locale.

## Change language (runtime)

Call `LocalizationService.updateLanguage('{code}')` with a key from `supportedLanguages` (`en`, `ar`, …). If the code is not supported, add the language first, then switch.

## Add a string key

1. Add `static const String {camel} = '{snake or short key}';` on `Strings`.
2. Add `{Strings.{camel}: '...'}` to **every** existing language map with the real translation (ask the user for copy you do not know).
3. Use `Strings.{camel}.tr` in UI.

Done when the key exists on `Strings` and in every language map.

## Add a language

Need a language code (`fr`) and a locale (`fr`, `FR`).

1. `supportedLanguages['fr'] = const Locale('fr', 'FR');`
2. Font family for that code in `supportedLanguagesFontsFamilies`. The family must already be registered in `assets/fonts/` and `pubspec.yaml`. If it is not, stop and say the font files are missing. Until then you may temporarily reuse `Poppins` and tell the user.
3. New file `lib/config/translations/fr_FR/fr_fr_translation.dart`:

```dart
import '../strings_enum.dart';

const Map<String, String> frFR = {
  Strings.hello: 'Bonjour !',
  // every existing Strings.* key must have a value here
};
```

Copy the full key set from an existing map, then fill translations. If the user did not provide them, keep English as a placeholder and tell them which keys still need copy.

4. Import that map and add `'fr_FR': frFR` to `keys`.

The `keys` map key is `{language}_{COUNTRY}` matching the `Locale` (`en_US`, `ar_AR`, `fr_FR`).

Done when `supportedLanguages`, `keys`, the new map file, and `supportedLanguagesFontsFamilies` all include the language, and the new map contains every `Strings` key.
