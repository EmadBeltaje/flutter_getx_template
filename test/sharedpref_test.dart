import 'package:flutter_test/flutter_test.dart';
import 'package:getx_skeleton/app/data/local/my_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// test shared pref (read & write)


Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // mock initial data
  Map<String, Object> values = <String, Object>{};
  SharedPreferences.setMockInitialValues(values);

  await MySharedPref.init();

  test('clear all the data from storage',() async {
    // set new token in shared pref
    await MySharedPref.setFcmToken('token');

    // check if the token stored
    String? token = MySharedPref.getFcmToken();

    // token must be set correctly
    expect(token, isNotNull);

    // clear all data
    await MySharedPref.clear();

    // token must be null now after clearing data
    String? tokenAfterClearing = MySharedPref.getFcmToken();

    // token must be null
    expect(tokenAfterClearing, isNull);
  });


  test('test read and write', () async {
    // set theme is light to false (write operation)
    await MySharedPref.setThemeIsLight(false);

    // get the value and test if the saving went fine (read operation)
    bool themeIsLight = MySharedPref.getThemeIsLight();

    // make sure write and read went fine
    expect(themeIsLight, false);
  });
}