import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/translations/strings_enum.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.favourite.tr),
    );
  }
}
