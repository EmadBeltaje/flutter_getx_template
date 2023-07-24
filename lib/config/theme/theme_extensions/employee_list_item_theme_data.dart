import 'package:flutter/material.dart';

class EmployeeListItemThemeData extends ThemeExtension<EmployeeListItemThemeData> {
  final TextStyle? nameTextStyle;
  final TextStyle? subtitleTextStyle;
  final IconThemeData? iconTheme;
  final Color? backgroundColor;

  const EmployeeListItemThemeData({
    this.nameTextStyle,
    this.subtitleTextStyle,
    this.iconTheme,
    this.backgroundColor,
  });

  @override
  ThemeExtension<EmployeeListItemThemeData> copyWith() {
    return EmployeeListItemThemeData(
      nameTextStyle: nameTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      iconTheme: iconTheme,
      backgroundColor: backgroundColor,
    );
  }

  @override
  EmployeeListItemThemeData lerp(ThemeExtension<EmployeeListItemThemeData>? other, double t) {
    if(other is! EmployeeListItemThemeData) {
      return this;
    }

    return EmployeeListItemThemeData(
      nameTextStyle: TextStyle.lerp(
        nameTextStyle,
        other.nameTextStyle,
        t,
      ),
      subtitleTextStyle: TextStyle.lerp(
        subtitleTextStyle,
        other.subtitleTextStyle,
        t,
      ),
      iconTheme: IconThemeData.lerp(
        iconTheme,
        other.iconTheme,
        t,
      ),
      backgroundColor: Color.lerp(
        backgroundColor,
        other.backgroundColor,
        t,
      )
    );
  }
}
