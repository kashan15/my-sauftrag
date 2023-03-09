import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

NotificationDetails get _noSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'silent channel id',
    'silent channel name',
    playSound: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

  return NotificationDetails(android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
}

Future showSilentNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String? title,
      @required String? body,
      @required payload,
      int id = 0,
    }) =>
    _showNotification(notifications, title: title ?? "", body: body ?? "", id: id, type: _noSound,payload: payload);

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: false,
    autoCancel: true,
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
}

Future showOngoingNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String? title,
      @required String? body,
      @required payload,
      int id = 0,
    }) =>
    _showNotification(notifications, title: title ?? "", body: body ?? "", id: id, type: _ongoing, payload: payload);

Future _showNotification(
    FlutterLocalNotificationsPlugin notifications, {
      @required String? title,
      @required String? body,
      @required NotificationDetails? type,
      @required payload,
      int id = 0,
    }) =>
    notifications.show(id, title, body, type, payload: json.encode(payload ?? {}));
