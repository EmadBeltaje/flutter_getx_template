import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/config/theme/my_fonts.dart';

import '../../app/data/local/my_shared_pref.dart';
import 'dark_theme_colors.dart';
import 'light_theme_colors.dart';
import 'my_styles.dart';
import 'theme_extensions/employee_list_item_theme_data.dart';

class MyTheme {
  static getThemeData({required bool isLight}){
    return ThemeData(
      // main color (app bar,tabs..etc)
        primaryColor: isLight ? LightThemeColors.primaryColor : DarkThemeColors.primaryColor,

        // secondary & background color
        colorScheme: ColorScheme.fromSwatch(
          accentColor: isLight ? LightThemeColors.accentColor : DarkThemeColors.accentColor,
          backgroundColor: isLight ? LightThemeColors.backgroundColor : DarkThemeColors.backgroundColor,
          brightness: isLight ? Brightness.light : Brightness.dark,
        )
            .copyWith(
          secondary: isLight ? LightThemeColors.accentColor : DarkThemeColors.accentColor,
        ),

        // color contrast (if the theme is dark text should be white for example)
        brightness: isLight ? Brightness.light : Brightness.dark,

        // card widget background color
        cardColor: isLight ? LightThemeColors.cardColor : DarkThemeColors.cardColor,

        // hint text color
        hintColor: isLight ? LightThemeColors.hintTextColor : DarkThemeColors.hintTextColor,

        // divider color
        dividerColor: isLight ? LightThemeColors.dividerColor : DarkThemeColors.dividerColor,

        // app background color
        scaffoldBackgroundColor: isLight ? LightThemeColors.scaffoldBackgroundColor : DarkThemeColors.scaffoldBackgroundColor,

        // progress bar theme
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: isLight ? LightThemeColors.primaryColor : DarkThemeColors.primaryColor,
        ),

        // appBar theme
        appBarTheme: MyStyles.getAppBarTheme(isLightTheme: isLight),

        // elevated button theme
        elevatedButtonTheme: MyStyles.getElevatedButtonTheme(isLightTheme: isLight),

        // text theme
        textTheme: MyStyles.getTextTheme(isLightTheme: isLight),

        // chip theme
        chipTheme: MyStyles.getChipTheme(isLightTheme: isLight),

        // icon theme
        iconTheme: MyStyles.getIconTheme(isLightTheme: isLight),

        // list tile theme
        listTileTheme: MyStyles.getListTileThemeData(isLightTheme: isLight),

        // custom themes
        extensions: [
          MyStyles.getHeaderContainerTheme(isLightTheme: isLight),
          MyStyles.getEmployeeListItemTheme(isLightTheme: isLight),
        ]
    );
  }

  /// update app theme and save theme type to shared pref
  /// (so when the app is killed and up again theme will remain the same)
  static changeTheme(){
    // *) check if the current theme is light (default is light)
    bool isLightTheme = MySharedPref.getThemeIsLight();

    // *) store the new theme mode on get storage
    MySharedPref.setThemeIsLight(!isLightTheme);

    // *) let GetX change theme
    Get.changeThemeMode(!isLightTheme ? ThemeMode.light : ThemeMode.dark);
  }

  /// check if the theme is light or dark
  bool get getThemeIsLight => MySharedPref.getThemeIsLight();
}