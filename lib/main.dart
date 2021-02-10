import 'dart:convert';

import 'package:deltarider2/config.dart';
import 'package:deltarider2/field/password_field.dart';
import 'package:deltarider2/field/user_field.dart';
import 'package:deltarider2/main_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

import 'api/order_api.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dynamic token = await FlutterSession().get('token');
  if (token == null) {
    token = '';
  }
  MyHomeApp().setNode();
  // print(token);
  runApp(MaterialApp(
    home: token == '' ? MyApp() : MyHomeApp(),
    theme:
        ThemeData(textButtonTheme: TextButtonThemeData(), fontFamily: 'Kanit'),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  TextEditingController _user = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  bool _isLoginOk = true;
  bool _buttonEnable = true;

  bool isEmpty() {
    setState(() {
      if (_user.text != '' && _pass.text != '') {
        _buttonEnable = false;
      } else {
        _buttonEnable = true;
      }
    });
    return _buttonEnable;
  }

  Future<void> clickLogin() async {
    String params = jsonEncode(
        <String, String>{'username': _user.text, 'password': _pass.text});

    await http.post('${Config.API_URL}/login', body: params).then((res) async {
      print(res.body);
      Map resMap = jsonDecode(res.body) as Map;
      int data = resMap['flag'];
      if (data == 0) {
        setState(() {
          _isLoginOk = false;
          print('fail');
        });
      } else {
        await FlutterSession().set('token', res.body);
        setState(() {
          _isLoginOk = true;
          print('success');
          Navigator.of(context).pop();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new MyHomeApp()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.indigo[600],
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(200)),
                color: Color.fromRGBO(255, 255, 255, 0.4),
                child: Container(
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              widthFactor: 10,
              heightFactor: 10,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(200)),
                color: Color.fromRGBO(255, 255, 255, 0.4),
                child: Container(
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 400,
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      //elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Image.asset(
                          'assets/images/login_logo.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'DeltaRider',
                        style: TextStyle(fontSize: 34, color: Colors.white),
                      ),
                    ),
                    _isLoginOk
                        ? Padding(padding: EdgeInsets.zero)
                        : Container(
                            margin: EdgeInsets.only(bottom: 10),
                            color: Colors.white70,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'ชื่อผู้ใช้ หรือ รหัสผ่าน ไม่ถูกต้อง',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                    UserField(Icon(Icons.person, color: Colors.white),
                        ' username', _user, isEmpty),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    PasswordField(Icon(Icons.lock, color: Colors.white),
                        'password', _pass, isEmpty),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      width: 150,
                      height: 60,
                      child: RaisedButton(
                        onPressed: _buttonEnable ? null : clickLogin,
                        color: Colors.orange,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
