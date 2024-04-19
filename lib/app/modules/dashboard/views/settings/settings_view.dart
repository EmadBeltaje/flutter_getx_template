import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/translations/strings_enum.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.settings.tr),
    );
  }
}
