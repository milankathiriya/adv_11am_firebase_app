import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as timezone;

class LocalNotificationHelper {
  LocalNotificationHelper._();
  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    var androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("====================");
        print("Payload => ${response.payload}");
        print("====================");
      },
    );
  }

  Future<void> showSimpleNotification() async {
    var androidNotificationDetails = AndroidNotificationDetails(
      "1",
      "Simple Channel",
      importance: Importance.max,
      priority: Priority.max,
    );
    var iosNotificationDetails = DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      "Simple Notification",
      "Dummy Body",
      notificationDetails,
      payload: "Sample Payload",
    );
  }

  Future<void> showScheduledNotification() async {
    var androidNotificationDetails = AndroidNotificationDetails(
      "2",
      "Scheduled Channel",
      importance: Importance.max,
      priority: Priority.max,
    );
    var iosNotificationDetails = DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      "Scheduled Notification",
      "Dummy Body",
      timezone.TZDateTime.now(timezone.local).add(Duration(seconds: 3)),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Sample Payload",
    );
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      contentTitle: "Big Pic Notification",
      largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
    );

    var androidNotificationDetails = AndroidNotificationDetails(
      "3",
      "Big Picture Channel",
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: bigPictureStyleInformation,
    );

    var notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: null);

    await flutterLocalNotificationsPlugin.show(
      3,
      "Big Pic Notification",
      "Dummy Body",
      notificationDetails,
      payload: "Sample Payload",
    );
  }

  Future<void> showMediaStyleNotification() async {
    var androidNotificationDetails = AndroidNotificationDetails(
      "4",
      "Media Style Channel",
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: MediaStyleInformation(),
      largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      enableLights: true,
      enableVibration: true,
      colorized: true,
      color: Colors.red,
    );

    var notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: null);

    await flutterLocalNotificationsPlugin.show(
      4,
      "Media Style Notification",
      "Dummy Body",
      notificationDetails,
      payload: "Sample Payload",
    );
  }
}
