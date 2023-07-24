import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/translations/strings_enum.dart';

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({super.key, required this.message, required this.retryAction, this.padding});

  final String message;
  final Function retryAction;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            10.verticalSpace,
            SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () => retryAction(), child: Text(Strings.retry.tr),)),
          ],
        ),
      ),
    );
  }
}
