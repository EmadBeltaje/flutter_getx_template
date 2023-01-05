import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/local/my_shared_pref.dart';
import 'package:getx_skeleton/config/translations/localization_service.dart';
import 'package:getx_skeleton/config/translations/strings_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
  });

  // mock initial data
  Map<String, Object> values = <String, Object>{};
  SharedPreferences.setMockInitialValues(values);

  await MySharedPref.init();

  test('check if language is supported', (){
    // check if English is supported
    bool isEnSupported = LocalizationService.isLanguageSupported('en');
    expect(isEnSupported, true);

    // check if French supported
    bool isFrSupported = LocalizationService.isLanguageSupported('fr');
    expect(isFrSupported, false);
  });


  test('Check getting/updating current local', () async {
    await LocalizationService.updateLanguage('en');
    Locale currentLocale = LocalizationService.getCurrentLocal();
    expect(currentLocale.languageCode, 'en');

    await LocalizationService.updateLanguage('ar');
    Locale currentLocaleAfterUpdate = LocalizationService.getCurrentLocal();
    expect(currentLocaleAfterUpdate.languageCode, 'ar');
  });


  test('Check if current language is English', () async {
      await LocalizationService.updateLanguage('en');
      bool isCurrentLangIsEnglish = LocalizationService.getCurrentLocal().languageCode.contains('en');
      expect(isCurrentLangIsEnglish, true);

      await LocalizationService.updateLanguage('ar');
      bool isCurrentLangEnglishAfterUpdate = LocalizationService.getCurrentLocal().languageCode.contains('ar');
      expect(isCurrentLangEnglishAfterUpdate, true);
  });


  testWidgets('Check translation', (tester) async {
    Get.testMode = false;
    await tester.pumpWidget(GetMaterialApp(
      locale: MySharedPref.getCurrentLocal(),
      translations: LocalizationService.getInstance(),
      home: const Scaffold(
        body: Center(child: Text('Testing..')),
      ),
    ));
    await tester.pumpAndSettle();

    // make language english and test the word value
    await LocalizationService.updateLanguage('en');

    await tester.pumpAndSettle();
    String helloWord = Strings.hello.tr;
    expect(helloWord, 'Hello!');

    // make language english and test the word value
    await LocalizationService.updateLanguage('ar');
    await tester.pumpAndSettle();
    String helloWordAfterChangingLanguage = Strings.hello.tr;
    expect(helloWordAfterChangingLanguage, 'مرحباً!');
  });
}