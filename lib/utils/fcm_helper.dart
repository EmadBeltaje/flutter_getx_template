import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../app/data/local/my_shared_pref.dart';
import '../app/routes/app_pages.dart';

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// IMPORTANT NOTE
// if you have errors here (undefined or awesome notifications doesnt have this funcition)
// this mean you are using old version of awesome notifications so you just need to go to
// template on github and copy older version of fcm_helper.dart class and paste it here
// link: https://github.com/EmadBeltaje/flutter_getx_template/commits/master/lib/utils/fcm_helper.dart
// you can copy the hole file of initial commit and paste here and everything would be fine
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// DUPLICATED NOTIFICATION ISSUE
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// you may get 2 notifications shown while you only sent 1 but why ?
// simply bcz one notification is from fcm and the other one is from us (awesome notification)
// but what does that mean!
// if you take a look here at this link https://firebase.google.com/docs/cloud-messaging/concept-options#notifications_and_data_messages
// you will know that notifications are 2 types
// - Notification message (which automatically show notification which lead to duplicated)
// - Data message (dont show notification so you must show it using awesome notifications)
// so if you want to get rid of duplicated notifications just stop sending (Notification message) and start sending (data message) instead
// and this is in most of time (api developer) responsibility
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

class FcmHelper {
  // FCM Messaging
  static late FirebaseMessaging messaging;

  // Notification lib
  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize fcm and firebase core
      await Firebase.initializeApp(
        // TODO: uncomment this line if you connected to firebase via cli
        //options: DefaultFirebaseOptions.currentPlatform,
      );
      messaging = FirebaseMessaging.instance;

      // initialize notifications channel and libraries
      await _initNotification();

      // notification settings handler
      await _setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await _generateFcmToken();

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

      // listen to notifications click and actions
      listenToActionButtons();
    } catch (error) {
      // if you are connected to firebase and still get error
      // check the todo up in the function else ignore the error
      // or stop fcm service from main.dart class
      Logger().e(error);
    }
  }

  /// when user click on notification or click on button on the notification
  static listenToActionButtons() {
    // Only after at least the action method is set, the notification events are delivered
    awesomeNotifications.setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> _setupFcmNotificationSettings() async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> _generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      Logger().e(token);
      print(token);
      if(token != null){
        MySharedPref.setFcmToken(token);
        _sendFcmTokenToServer();
      }else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        _generateFcmToken();
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  /// this method will be triggered when the app generate fcm
  /// token successfully
  static _sendFcmTokenToServer(){
    var token = MySharedPref.getFcmToken();
    // TODO SEND FCM TOKEN TO SERVER
  }

  ///handle fcm notification when app is closed/terminated
  /// if you are wondering about this annotation read the following
  /// https://stackoverflow.com/a/67083337
  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    _showNotification(
      id: 1,
      title: message.notification?.title ?? 'Tittle',
      body: message.notification?.body ?? 'Body',
      payload: message.data.cast(), // pass payload to the notification card so you can use it (when user click on notification)
    );
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    _showNotification(
      id: 1,
      title: message.notification?.title ?? 'Tittle',
      body: message.notification?.body ?? 'Body',
      payload: message.data.cast(), // pass payload to the notification card so you can use it (when user click on notification)
    );
  }

  //display notification for user with sound
  static _showNotification(
      {required String title,
        required String body,
        required int id,
        String? channelKey,
        String? groupKey,
        NotificationLayout? notificationLayout,
        String? summary,
        Map<String, String>? payload,
        String? largeIcon}) async {
    awesomeNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        awesomeNotifications.requestPermissionToSendNotifications();
      } else {
        // u can show notification
        awesomeNotifications.createNotification(
          content: NotificationContent(
            id: id,
            title: title,
            body: body,
            groupKey: groupKey ?? NotificationChannels.generalGroupKey,
            channelKey: channelKey ?? NotificationChannels.generalChannelKey,
            showWhen: true, // Hide/show the time elapsed since notification was displayed
            payload: payload, // data of the notification (it will be used when user clicks on notification)
            notificationLayout: notificationLayout ?? NotificationLayout.Default, // notification shape (message,media player..etc) For ex => NotificationLayout.Messaging
            autoDismissible: true, // dismiss notification when user clicks on it
            summary: summary, // for ex: New message (it will be shown on status bar before notificaiton shows up)
            largeIcon: largeIcon, // image of sender for ex (when someone send you message his image will be shown)
          ),
        );
      }
    });
  }

  ///init notifications channels
  static _initNotification() async {
    await awesomeNotifications.initialize(
        null, // null mean it will show app icon on the notification (status bar)
        [
          NotificationChannel(
            channelGroupKey: NotificationChannels.generalChannelGroupKey,
            channelKey: NotificationChannels.generalChannelKey,
            channelName: NotificationChannels.generalChannelName,
            groupKey: NotificationChannels.generalGroupKey,
            channelDescription: 'Notification channel for general notifications',
            defaultColor: Colors.green,
            ledColor: Colors.white,
            channelShowBadge: true,
            playSound: true,
            importance: NotificationImportance.Max,
          ),
          NotificationChannel(
              channelGroupKey: NotificationChannels.chatChannelGroupKey,
              channelKey: NotificationChannels.chatChannelKey,
              channelName: NotificationChannels.chatChannelName,
              groupKey: NotificationChannels.chatGroupKey,
              channelDescription: 'Notification channel for messages',
              defaultColor: Colors.green,
              ledColor: Colors.white,
              channelShowBadge: true,
              playSound: true,
              importance: NotificationImportance.Max)
        ],

        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: NotificationChannels.generalChannelGroupKey,
            channelGroupName: NotificationChannels.generalChannelGroupName,
          ),
          NotificationChannelGroup(
            channelGroupKey: NotificationChannels.chatChannelGroupKey,
            channelGroupName: NotificationChannels.chatChannelGroupName,
          )
        ]);
  }
}

class NotificationChannels {
  // chat channel (for messages only)
  static String get chatChannelKey => "chat_channel";
  static String get chatChannelName => "Chat channel";
  static String get chatGroupKey => "chat group key";
  static String get chatChannelGroupKey => "chat_channel_group";
  static String get chatChannelGroupName => "Chat notifications channels";
  static String get chatChannelDescription => "Chat notifications channels";

  // general channel (for all other notifications)
  static String get generalChannelKey => "fitness_channel";
  static String get generalGroupKey => "basic group key";
  static String get generalChannelGroupKey => "basic_channel_group";
  static String get generalChannelGroupName => "Fitness public notifications channels";
  static String get generalChannelName => "Fitness notifications channels";
  static String get generalChannelDescription => "Notification channel for messages";
}

class NotificationController {

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    Map<String,String?>? payload = receivedAction.payload;
    Logger().e(payload);
    // example
    // String routeToGetTo = payload['route'];
    // normal navigation (Get.toNamed) will throw error
    Get.key.currentState?.pushNamed(Routes.HOME);
  }
}

