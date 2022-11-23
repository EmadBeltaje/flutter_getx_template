import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../config/translations/strings_enum.dart';




/// this method will show black overlay which look like dialog
/// and it will have loading animation inside of it
/// this will make sure user cant interact with ui until
/// any (async) method is executing cuz it will wait for async function
/// to end and then it will dismiss the overlay
showLoadingOverLay({required Future<dynamic> Function() asyncFunction,String? msg,}) async
{
  await Get.showOverlay(asyncFunction: () async {
    try{
      await asyncFunction();
    }catch(error){
      Logger().e(error);
      Logger().e(StackTrace.current);
    }
  },loadingWidget: Center(
    child: _getLoadingIndicator(msg: msg),
  ),opacity: 0.7,
    opacityColor: Colors.black,
  );
}

Widget _getLoadingIndicator({String? msg}){
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 20.w,
      vertical: 10.h,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: Colors.white,
    ),
    child: Column(mainAxisSize: MainAxisSize.min,children: [
      Image.asset('assets/images/app_icon.png',height: 45.h,),
      SizedBox(width: 8.h,),
      Text(msg ?? Strings.loading.tr,style: Get.theme.textTheme.bodyText1),
    ],),
  );
}