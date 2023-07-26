import 'package:flutter/cupertino.dart';

import '../services/api_call_status.dart';

// switch between different widgets with animation
// depending on api call status
class MyWidgetsAnimator extends StatelessWidget {
  final ApiCallStatus apiCallStatus;
  final Widget Function() loadingWidget;
  final Widget Function() successWidget;
  final Widget Function() errorWidget;
  final Widget Function()? emptyWidget;
  final Widget Function()? holdingWidget;
  final Widget Function()? refreshWidget;
  final Duration? animationDuration;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;
  // this will be used to not hide the success widget when refresh
  // if its true success widget will still be shown
  // if false refresh widget will be shown or empty box if passed (refreshWidget) is null
  final bool hideSuccessWidgetWhileRefreshing;


  const MyWidgetsAnimator(
      {Key? key,
        required this.apiCallStatus,
        required this.loadingWidget,
        required this.errorWidget,
        required this.successWidget,
        this.holdingWidget,
        this.emptyWidget,
        this.refreshWidget,
        this.animationDuration,
        this.transitionBuilder,
        this.hideSuccessWidgetWhileRefreshing = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration ?? const Duration(milliseconds: 300),
      child: switch(apiCallStatus){
        (ApiCallStatus.success) => successWidget,
        (ApiCallStatus.error) => errorWidget,
        (ApiCallStatus.holding) => holdingWidget ?? () { return const SizedBox();},
        (ApiCallStatus.loading) => loadingWidget,
        (ApiCallStatus.empty) => emptyWidget ?? (){return const SizedBox();},
        (ApiCallStatus.refresh) => refreshWidget ?? (hideSuccessWidgetWhileRefreshing ? successWidget :  (){return const SizedBox();}),
        (ApiCallStatus.cache) => successWidget,
      }(),
      transitionBuilder: transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder
    );
  }
}
