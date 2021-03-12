import 'dart:convert';
import 'dart:typed_data';

import 'package:deltarider2/api/toJsonLocation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_session/flutter_session.dart';
import '../main.dart';
import '../main_order.dart';
import 'toJsonReceiveOrders.dart';
import 'toJsonOrder.dart';
import 'package:http/http.dart' as http;
import 'package:deltarider2/config.dart';
import 'toJsonDetailFood.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<List<Orders>> fetchOrders() async {
  dynamic token = await FlutterSession().get('token');
  String idRes = token['data']['id_res_auto'];
  final res = await http.get("${Config.API_URL}/load_order/$idRes");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  //print(jsonDecode(res.body));
  return ordersFromJson(res.body);
}

Future<List<ReceiveOrders>> fetchReceiveOrders() async {
  dynamic token = await FlutterSession().get('token');
  String riderID = token['data']['admin_id'];
  String idRes = token['data']['id_res_auto'];
  final res =
      await http.get("${Config.API_URL}/load_order_reserve/$idRes/$riderID");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  //print(jsonDecode(res.body));
  return receiveOrdersFromJson(res.body);
}

Future<List<DetailFood>> fetchDetailFood(String orderID) async {
  final res = await http.get("${Config.API_URL}/load_item/$orderID");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  // print(jsonDecode(res.body));
  return detailFoodFromJson(res.body);
}

Future<List<Locations>> fetchLocation() async {
  dynamic token = await FlutterSession().get('token');
  String riderID = token['data']['admin_id'];
  String idResAuto = token['data']['id_res_auto'];
  final res = await http
      .get("${Config.API_URL}/get_location/$idResAuto/$riderID?lang=th");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }

  return locationsFromJson(res.body);
}

Stream<List<Orders>> getOrders() async* {
  Future.delayed(Duration(seconds: 3));
  print('get1');
  yield await fetchOrders();
}

Stream<List<ReceiveOrders>> getReceiveOrders() async* {
  Future.delayed(Duration(seconds: 3));
  print('get2');
  yield await fetchReceiveOrders();
}

Future<Null> showNotification({title, body}) async {
  final Int64List vibrationPattern = new Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 500;
  vibrationPattern[3] = 2000;

  var android = new AndroidNotificationDetails(
    'channel id',
    'channel NAME',
    'CHANNEL DESCRIPTION',
    priority: Priority.high,
    importance: Importance.max,
    vibrationPattern: vibrationPattern,
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: iOS);
  await flutterLocalNotificationsPlugin.show(0, title, body, platform,
      payload: 'AndroidCoding.in');

  print('notify');
}

void requestIOSPermissions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

void initFirebaseMessaging() {
  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      Map mapNotification = message["notification"];
      String title = mapNotification["title"];
      String body = mapNotification["body"];
      showNotification(title: title, body: body);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
    },
    onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
    },
  );

  firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
}
