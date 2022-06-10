import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../config/translations/strings_enum.dart';




/// this method will show black overlay which look like dialog
/// and it will have loading animation inside of it
/// this will make sure user cant interact with ui until
/// any (async) method is excuting cuz it will wait for asyn function
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
    child: getLoadingIndicator(msg: msg),
  ),opacity: 0.7,
    opacityColor: Colors.black,
  );
}

Widget getLoadingIndicator({String? msg}){
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









// // show loading dialog
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:progress_indicators/progress_indicators.dart';
// import 'package:logger/logger.dart';
//
//
// /// this method will show black overlay which look like dialog
// /// and it will have loading animation inside of it
// /// this will make sure user cant interact with ui until
// /// any (async) method is excuting cuz it will wait for asyn function
// /// to end and then it will dismiss the overlay
// showLoadingOverLay({required Future<dynamic> Function() asyncFunction,String? msg,Widget? progress}) async
// {
//   try{
//     await Get.showOverlay(asyncFunction: ()async {
//       isOverlayOpened = true;
//       await asyncFunction();
//       isOverlayOpened = false;
//     },loadingWidget: Center(
//       child: getLoadingIndicator(message: msg,progress: progress),
//     ),opacity: 0.85,
//       opacityColor: Colors.black,
//     );
//   }catch(e){
//     Logger().e(e);
//   }
// }
//
// Widget getLoadingIndicator({Color? color,String? message,Widget? progress}){
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Dialog(
//         child: Container(
//           height: 80.h,
//           width: Get.width,
//           child: Row(
//             children: [
//               Image.asset('assets/images/app_logo.png',height: 100.h,),
//               SizedBox(width: 10.w),
//               Expanded(
//                 child: Text('Loading...',style: Get.theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.normal)),
//                // child: FadingText('Loading...',style: Get.theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.normal)),
//               )
//               // LoadingIndicator(
//               //   indicatorType: Indicator.ballSpinFadeLoader,    /// Required, The loading type of the widget
//               //   colors: [
//               //     Colors.red,
//               //     Colors.orange,
//               //     Colors.yellow,
//               //     Colors.green,
//               //     Colors.blueAccent,
//               //     Colors.blue,
//               //     Colors.purple,
//               //     Colors.red,
//               //     Colors.orange,
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ),
//       //   LoadingIndicator(
//       //     indicatorType: Indicator.pacman,    /// Required, The loading type of the widget
//       //     colors: [color ?? Colors.yellow,Colors.orangeAccent,Colors.redAccent],
//       //   ),
//       // ),
//       if(message != null)
//       SizedBox(height: 10.h,),
//       if(message != null)
//       Material(color: Colors.transparent,child: Text(message,style: Get.theme.textTheme.bodyText1!.copyWith(color: Colors.white))),
//       if(progress != null)
//         SizedBox(height: 10.h,),
//       if(progress != null)
//         progress
//     ],
//   );
// }
//
// var isOverlayOpened = false;