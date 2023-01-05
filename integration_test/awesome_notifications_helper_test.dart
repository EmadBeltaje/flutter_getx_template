import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/utils/awesome_notifications_helper.dart';
import 'package:integration_test/integration_test.dart';


/// test awesome notifications helper class
/// 1- check if notifications shows up
/// 2- check if handlers work fine
/// 3- check action handler (when you click on notification action buttons)
/// at the end of test lower your mobile/emulator status bar to see the notifications
/// they should be grouped in 2 groups (4 in general channel & 4 in chat channel)


main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // initialize awesome notifications
  await AwesomeNotificationsHelper.init();

  testWidgets('Test showing local notification using awesome notifications', (tester) async {
    // create controller for test
    TestController controller = Get.put<TestController>(TestController());

    // set mock controller for awesome notification (just for test)
    AwesomeNotificationsHelper.awesomeNotifications.setListeners(
        onActionReceivedMethod:         MockNotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    MockNotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  MockNotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  MockNotificationController.onDismissActionReceivedMethod
    );

    // pump widget
    await tester.pumpWidget(const TestWidget());

    // request permission to show notifications
    bool showNotificationsPermissionGranted = await AwesomeNotificationsHelper.awesomeNotifications.requestPermissionToSendNotifications();

    // if user didn't give permission then we cant show notifications
    if(showNotificationsPermissionGranted == false) return;

    // pump widget when value of counter or action changed
    // this is only for integration test other wise ui should
    // be updated directly without needing for this code..
    controller.notificationsCounter.stream.listen((event) async {
      await tester.pump();
    });
    controller.notificationAction.stream.listen((event) async {
      await tester.pump();
    });

    // find floating button
    Finder generalNotificationsFab = find.byKey(const ValueKey('general_notifications_fap'));
    Finder chatNotificationsFab = find.byKey(const ValueKey('chat_notifications_fap'));

    // press on fab button to show notifications
    await tester.tap(generalNotificationsFab);
    await Future.delayed(const Duration(seconds: 3));
    await tester.tap(generalNotificationsFab);
    await Future.delayed(const Duration(seconds: 3));
    await tester.tap(generalNotificationsFab);
    await Future.delayed(const Duration(seconds: 3));
    await tester.tap(generalNotificationsFab);
    await Future.delayed(const Duration(seconds: 5));

    // press on fab button to show notifications
    await tester.tap(chatNotificationsFab);
    await Future.delayed(const Duration(seconds: 3));
    await tester.tap(chatNotificationsFab);
    await Future.delayed(const Duration(seconds: 3));
    await tester.tap(chatNotificationsFab);
    await Future.delayed(const Duration(seconds: 3));
    await tester.tap(chatNotificationsFab);
    await Future.delayed(const Duration(seconds: 5));

    // we displayed 4 notifications
    expect(controller.notificationsCounter.value, 8);

    // wait before closing app/test
    await Future.delayed(const Duration(seconds: 30));
  });
}


class TestController extends GetxController {
  // notifications counter
  Rx<int> notificationsCounter = 0.obs;
  // when user click on action button
  Rx<String> notificationAction = ''.obs;

  incrementCounter() {
    notificationsCounter.value += 1;
  }

  decrementCounter() {
    notificationsCounter.value -= 1;
  }

  onNotificationActionClicked(String actionKey){
    notificationAction.value = actionKey;
  }
}

class TestWidget extends GetWidget<TestController> {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Notifications Count => ${controller.notificationsCounter.value}'),
                Text('Notifications Action => ${controller.notificationAction.value}'),
              ],
            )),
          ),
        ),
        floatingActionButton: Row(
          children: [
            FloatingActionButton(
              key: const ValueKey('general_notifications_fap'),
              child: const Icon(Icons.add,color: Colors.white,),
              backgroundColor: Colors.purple,
              onPressed: () async {
                await AwesomeNotificationsHelper.showNotification(
                    title: 'test number ${controller.notificationsCounter.value}',
                    body: 'test notification number ${controller.notificationsCounter.value}',
                    id: controller.notificationsCounter.value,
                    actionButtons: [
                      NotificationActionButton(key: 'submit', label: 'Submit'),
                      NotificationActionButton(key: 'cancel', label: 'Cancel'),
                    ]
                );
              },
            ),
            const SizedBox(width: 20,),
            FloatingActionButton(
              key: const ValueKey('chat_notifications_fap'),
              child: const Icon(Icons.add,color: Colors.white,),
              backgroundColor: Colors.blue,
              onPressed: () async {
                await AwesomeNotificationsHelper.showNotification(
                    title: 'test number ${controller.notificationsCounter.value}',
                    body: 'test notification number ${controller.notificationsCounter.value}',
                    id: controller.notificationsCounter.value,
                    channelKey: NotificationChannels.chatChannelKey,
                    groupKey: NotificationChannels.chatGroupKey,
                    actionButtons: [
                      NotificationActionButton(key: 'submit', label: 'Submit'),
                      NotificationActionButton(key: 'cancel', label: 'Cancel'),
                    ]
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MockNotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    Get.find<TestController>().incrementCounter();
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    Get.find<TestController>().decrementCounter();
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    Get.find<TestController>().onNotificationActionClicked(receivedAction.buttonKeyPressed);
  }
}

