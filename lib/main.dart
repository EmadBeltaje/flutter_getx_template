import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:getx_skeleton/utils/awesome_notifications_helper.dart';

import 'app/data/local/my_hive.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/data/models/user_model.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'utils/fcm_helper.dart';

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // initialize local db (hive) and register our custom adapters
  await MyHive.init(
      registerAdapters: (hive) {
        hive.registerAdapter(UserModelAdapter());
        //myHive.registerAdapter(OtherAdapter());
      }
  );

  // init shared preference
  await MySharedPref.init();

  // inti fcm services
  await FcmHelper.initFcm();

  // initialize local notifications service
  await AwesomeNotificationsHelper.init();

  runApp(
    ScreenUtilInit(
      // todo add your (Xd / Figma) artboard size
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
              // todo add your app name
              title: "GetXSkeleton",
              useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,
              builder: (context,widget) {
                bool themeIsLight = MySharedPref.getThemeIsLight();
                return Theme(
                  data: MyTheme.getThemeData(isLight: themeIsLight),
                  child: MediaQuery(
                    // prevent font from scalling (some people use big/small device fonts)
                    // but we want our app font to still the same and dont get affected
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  ),
                );
              },
              initialRoute: AppPages.INITIAL, // first screen to show when app is running
              getPages: AppPages.routes, // app screens
              locale: MySharedPref.getCurrentLocal(), // app language
              translations: LocalizationService.getInstance(), // localization services in app (controller app language)
            );
      },
    ),
  );
}
