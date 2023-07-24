import 'package:flutter/material.dart';

class HeaderContainerThemeData extends ThemeExtension<HeaderContainerThemeData> {
  final BoxDecoration? decoration;

  const HeaderContainerThemeData({
    this.decoration,
  });

  @override
  ThemeExtension<HeaderContainerThemeData> copyWith() {
    return HeaderContainerThemeData(
      decoration: decoration,
    );
  }

  @override
  ThemeExtension<HeaderContainerThemeData> lerp(covariant ThemeExtension<HeaderContainerThemeData>? other, double t) {
    if (other is! HeaderContainerThemeData) {
      return this;
    }

    return HeaderContainerThemeData(
      decoration: BoxDecoration.lerp(decoration, other.decoration, t) ?? BoxDecoration(borderRadius: BorderRadius.circular(8)), // If lerp returns null, use an empty BoxDecoration
    );
  }

}