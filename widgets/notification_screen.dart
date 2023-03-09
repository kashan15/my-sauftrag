import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sauftrag/widgets/notification_helper.dart';

class NotificationService {
  FirebaseMessaging? _messaging;
  FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  configure(Future<void> Function(RemoteMessage message) handler, currentContext) async {
    await Firebase.initializeApp();
    this._messaging = FirebaseMessaging.instance;
    await this._messaging?.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    var token = await FirebaseMessaging.instance.getToken();
    this._setupLocalNotification(currentContext);
    this._setupNotificationListener();

    FirebaseMessaging.onBackgroundMessage(handler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      this._handleData(message.data, currentContext);
    });

    return token;
  }

  Future _onSelectNotification(String payload) async => () {
    print("very good ho");
  };

  void _setupLocalNotification(currentContext) {
    final settingsAndroid = AndroidInitializationSettings("hazrin");
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => this._onSelectNotification(payload ?? ""));

    this._notifications.initialize(InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: (String? payload) => onSelectNotification(payload!, currentContext));
  }

  void _setupNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showOngoingNotification(this._notifications,
          title: message.notification?.title, body: message.notification?.body, payload: message.data);
    });
  }

  Future onSelectNotification(String payload, currentContext) async {
    if (payload != null) {
      this._handleData(json.decode(payload), currentContext);
    }
  }

  void _handleData(data, currentContext) {



    print('ammar:${data}');

    // mainViewModel.navigationService.navigateToReplacement(to: MainView(controllerIndex: 1,));
    // if (data['category_id'] != "0") {
    //   Navigator.of(currentContext).push(MaterialPageRoute(builder: (_) {
    //     return CategoryViewScreen(
    //       type: 'category',
    //       categoryID: int.parse(data['category_id']),
    //     );
    //   }));
    // } else if (data['product_id'] != "0") {
    //   print('prodid:${data['product_id']}');
    //   Navigator.of(currentContext).push(MaterialPageRoute(builder: (_) {
    //     return ProductDetails(productID: data['product_id']);
    //   }));
    // } else if (data['brand_id'] != "0") {
    //   print('brandid:${data['brand_id']}');
    //   Navigator.of(currentContext).push(MaterialPageRoute(builder: (_) {
    //     return CategoryViewScreen(
    //       type: 'brand',
    //       brandID: int.parse(data['brand_id']),
    //     );
    //   }));
    // } else if (data['trend_id'] != "0") {
    //   print('trendid:${data['trend_id']}');
    //   Navigator.of(currentContext).push(MaterialPageRoute(builder: (_) {
    //     return CategoryViewScreen(
    //       type: 'trend',
    //       trendID: int.parse(data['trend_id']),
    //     );
    //   }));
    // }
  }
}
