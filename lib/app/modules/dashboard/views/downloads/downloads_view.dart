import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/translations/strings_enum.dart';

class DownloadsView extends StatelessWidget {
  const DownloadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.downloads.tr),
    );
  }
}
