import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/my_widgets_animator.dart';
import 'package:getx_skeleton/app/services/api_call_status.dart';


/// widget animator test code to make sure the widget switch
/// correctly between different widgets according to api call status


class TestController extends GetxController {
  Rx<ApiCallStatus> apiCallStatus = ApiCallStatus.loading.obs;
}

class TestView extends StatelessWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Obx(
             () =>
               MyWidgetsAnimator(
                apiCallStatus: Get.find<TestController>().apiCallStatus.value,
                animationDuration: const Duration(seconds: 2),
                 loadingWidget: () => const Text('Loading',key: ValueKey('Loading'),),
                 errorWidget: ()=> const Text('Error',key: ValueKey('Error'),),
                 successWidget: () => const Text('Success',key: ValueKey('Success'),),
                 emptyWidget: () => const Text('Empty',key: ValueKey('Empty'),),
                 holdingWidget: () => const Text('Holding',key: ValueKey('Holding'),),
              ),
          ),
        ),
      ),
    );
  }
}



main() {
  testWidgets('test widget animator animating between widgets according to api call status', (tester) async {
    // initialize controller
    TestController controller = Get.put<TestController>(TestController());

    // animation controller (just a work around bcz animated switcher not working fine in integration test 'Flutter bug')
    final animationController = AnimationController(vsync: tester,duration: const Duration(seconds: 2));

    // pump widget
    await tester.pumpWidget(const TestView());

    // loading state (default) in the controller
    expect(find.text('Loading'), findsOneWidget);

    // error
    controller.apiCallStatus.value = ApiCallStatus.error;
    animationController.forward();
    await tester.pumpAndSettle();
    expect(find.text('Error'), findsOneWidget);

    // success
    controller.apiCallStatus.value = ApiCallStatus.success;
    animationController.forward();
    await tester.pumpAndSettle();
    expect(find.text('Success'), findsOneWidget);

    // holding
    controller.apiCallStatus.value = ApiCallStatus.holding;
    animationController.forward();
    await tester.pumpAndSettle();
    expect(find.text('Holding'), findsOneWidget);

    // empty
    controller.apiCallStatus.value = ApiCallStatus.empty;
    animationController.forward();
    await tester.pumpAndSettle();
    expect(find.text('Empty'), findsOneWidget);

    // wait before close test
    await Future.delayed(const Duration(seconds: 3));
    animationController.dispose();
  });
}