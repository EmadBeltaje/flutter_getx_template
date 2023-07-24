import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/config/theme/my_theme.dart';
import 'package:getx_skeleton/config/translations/localization_service.dart';

import '../../../../../config/theme/theme_extensions/header_container_theme_data.dart';
import '../../../../../config/translations/strings_enum.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 110.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primaryColor,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          //----------------white circles decor----------------//
          Positioned(
            right: 0,
            top: -125.h,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.05),
              radius: 111,
            ),
          ),
          Positioned(
            right: -7.w,
            top: -160.h,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.05),
              radius: 111,
            ),
          ),
          Positioned(
            right: -21.w,
            top: -195.h,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.05),
              radius: 111,
            ),
          ),

          //----------------Data row----------------//
          Positioned(
            bottom: 10,
            right: 16.w,
            left: 16.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 39.h,
                  width: 39.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE2C2),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.white,
                      width: 1
                    )
                  ),
                  child: Image.asset('assets/images/person1.png',height: double.infinity,),
                ),
                9.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${Strings.goodMorning.tr},🌞',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      Strings.name.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                //----------------Theme Button----------------//
                InkWell(
                  onTap: () => MyTheme.changeTheme(),
                  child: Ink(
                    child: Container(
                      height: 39.h,
                      width: 39.h,
                      decoration: theme.extension<HeaderContainerThemeData>()?.decoration,
                      child: SvgPicture.asset(
                        Get.isDarkMode ? 'assets/vectors/moon.svg' : 'assets/vectors/sun.svg',
                        fit: BoxFit.none,
                        color: Colors.white,
                        height: 10,
                        width: 10,
                      ),
                    ),
                  ),
                ),

                10.horizontalSpace,

                //----------------Language Button----------------//
                InkWell(
                  onTap: () => LocalizationService.updateLanguage(
                    LocalizationService.getCurrentLocal().languageCode == 'ar' ? 'en' : 'ar',
                  ),
                  child: Ink(
                    child: Container(
                      height: 39.h,
                      width: 39.h,
                      decoration: theme.extension<HeaderContainerThemeData>()?.decoration,
                      child: SvgPicture.asset(
                        'assets/vectors/language.svg',
                        fit: BoxFit.none,
                        color: Colors.white,
                        height: 10,
                        width: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
