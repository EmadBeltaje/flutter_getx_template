import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/data/local/my_shared_pref.dart';
import '../translations/localization_service.dart';

// todo configure text family and size
class MyFonts
{
  // return the right font depending on app language
  static TextStyle get getAppFontType => LocalizationService.supportedLanguagesFontsFamilies[MySharedPref.getCurrentLocal().languageCode]!;

  // headlines text font
  static TextStyle get displayTextStyle => getAppFontType;

  // body text font
  static TextStyle get bodyTextStyle => getAppFontType;

  // button text font
  static TextStyle get buttonTextStyle => getAppFontType;

  // app bar text font
  static TextStyle get appBarTextStyle  => getAppFontType;

  // chips text font
  static TextStyle get chipTextStyle  => getAppFontType;

  // appbar font size
  static double get appBarTittleSize => 18.sp;

  // body font size
  static double get bodySmallTextSize => 11.sp;
  static double get bodyMediumSize => 13.sp; // default font
  static double get bodyLargeSize => 16.sp;
  // display font size
  static double get displayLargeSize => 20.sp;
  static double get displayMediumSize => 17.sp;
  static double get displaySmallSize => 14.sp;

  //button font size
  static double get buttonTextSize => 16.sp;

  //chip font size
  static double get chipTextSize => 10.sp;

  // list tile fonts sizes
  static double get listTileTitleSize => 13.sp;
  static double get listTileSubtitleSize => 12.sp;

  // custom themes (extensions)
  static double get employeeListItemNameSize => 13.sp;
  static double get employeeListItemSubtitleSize => 13.sp;
}