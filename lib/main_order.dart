import 'dart:async';
import 'dart:convert';

import 'package:deltarider2/api/infoDevice.dart';
import 'package:deltarider2/drawer.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:deltarider2/location/location.dart';
import 'package:deltarider2/order/order.dart';
import 'package:deltarider2/recieve/send.dart';
import 'package:deltarider2/setting.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'api/order_api.dart';
import 'field/onLoad.dart';
import 'main.dart';

String id, code;
DatabaseReference databaseReference,
    databaseDelivery,
    databaseAddDelivery,
    databaseRider,
    databaseChat;
dynamic token;
Position position;
FToast fToast;
bool logout = false;

class MyHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('aaa');
    return MaterialApp(
      title: 'Delta Food',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Kanit',
      ),
      home: MyHomePage(),
      // darkTheme: ThemeData(
      //   accentColor: Colors.deepPurple[500],
      //   brightness: Brightness.dark,
      // ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location;
  int _selectedIndex = 0;
  final List<Widget> _children = [Order(), Send(), PageLocations(), Setting()];
  final List<String> _appBar = ['ออร์เดอร์', 'การจัดส่ง', 'แผนที่', ''];
  final GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime backButtonPressTime;

  void onItemTapped(int index) {
    if (!mounted) return;
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future notify() async {
    token = jsonDecode(sharedPreferences.getString('token'));
    id = token['data']['id_res_auto'];
    code = token['data']['code'];
    databaseAddDelivery =
        firebaseDatabase.reference().child('${id}_${code}/add_delivery');

    bool fist = true;
    databaseAddDelivery.onValue.listen((event) {
      if (!fist) {
        showNotification(
            title: 'ออร์เดอร์อัพเดต', body: 'รายการสั่งอาหารมาใหม่');
      } else {
        fist = false;
      }
      // print('change  ${event.snapshot.value}');
    });
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    setState(() {
      _selectedIndex = 0;
    });
  }

  Future checkGetCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) {
        getCurrentLocation();
        return;
      }
    }
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    if (!mounted) return;
    if (mounted) {
      Position res = await Geolocator.getCurrentPosition();
      setState(() {
        position = res;
      });
    }
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    getCurrentLocation();
    loadInfo();
    initFirebaseMessaging(context);

    databaseDelivery =
        firebaseDatabase.reference().child('${id}_${code}/delivery');
    databaseAddDelivery =
        firebaseDatabase.reference().child('${id}_${code}/add_delivery');
    databaseRider = firebaseDatabase.reference().child('${id}_${code}/rider');

    super.initState();
    // location = new Location();
    // location.onLocationChanged.listen((event) {
    //   getCurrentLocation();
    //   //print('lat ${position.latitude}   lng  ${position.longitude}');
    // });
    // databaseReference = firebaseDatabase.reference().child('${id}_${code}');

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android =
        new AndroidInitializationSettings('@drawable/icon_notification');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);
  }

  @override
  void didChangeDependencies() async {
    location = new Location();
    if (position == null) {
      getCurrentLocation();
    }
    location.onLocationChanged.listen((event) {
      getCurrentLocation();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    location.onLocationChanged.listen((event) {
      getCurrentLocation();
    }).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        centerTitle: true,
        title: Text('${_appBar[_selectedIndex]}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        toolbarHeight: 50,
      ),
      drawer: Drawer(
        //semanticLabel: 'aaa',
        child: MenuDrawer(),
      ),
      body: WillPopScope(
          child: _children[_selectedIndex], onWillPop: handleOnWillPop),
      bottomNavigationBar: new BottomNavigationBar(
        elevation: 50,
        iconSize: 25,
        //selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedFontSize: 11,
        selectedFontSize: 11,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            activeIcon: Icon(CupertinoIcons.square_list_fill),
            title: Text('ออร์เดอร์'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            title: Text('การจัดส่ง'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            title: Text('แผนที่'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.gear_alt),
          //   activeIcon: Icon(CupertinoIcons.gear_solid),
          //   title: Text('ตั้งค่า'),
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

  Future<bool> handleOnWillPop() async {
    DateTime now = DateTime.now();
    bool backButton = backButtonPressTime == null ||
        now.difference(backButtonPressTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressTime = now;
      showToastBottom(
          text: 'แตะอีกครั้งเพื่อออก',
          color: Colors.deepPurple.withOpacity(0.7));
      return false;
    }
    return true;
  }
}
