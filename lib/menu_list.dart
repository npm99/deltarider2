import 'dart:convert';

import 'package:deltarider2/api/infoDevice.dart';
import 'package:deltarider2/config.dart';
import 'package:deltarider2/edit_data/change_password.dart';
import 'package:deltarider2/main.dart';
import 'package:deltarider2/main_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  void onLogout() {
    DeviceInfo deviceInfo = DeviceInfo.fromJson(deviceData);
    String params = jsonEncode(
        <String, dynamic>{'uuid': deviceInfo.uuid, 'admin_id': token['data']['admin_id']});
    print(params);
    // http.post('${Config.API_URL}/logout', body:).then((value) {

    // });
    // FlutterSession().set('token', '');
    // Navigator.of(context).pop();
    // Navigator.push(context,
    //     new CupertinoPageRoute(builder: (BuildContext context) => new MyApp()));
  }

  void onChangePassword() {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (BuildContext context) => new ChangePassword()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(fontSize: 10, color: Colors.red),
        child: ListView(
          children: [
            changePassword(onChangePassword),
            logout(function: onLogout)
          ],
        ));
  }
}

Container urlList() {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: 0)
    ]),
    child: Card(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: Icon(Icons.language_outlined),
          title: Text(
            'http://delivery.deltafoodco./deltafood',
          ),
        ),
      ),
    ),
  );
}

Container changeUser(Function function) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    ]),
    child: Card(
      child: InkWell(
        onTap: () {
          function();
        },
        child: ListTile(
          leading: Icon(
            Icons.person_outline,
          ),
          title: Text('แก้ไขข้อมูลส่วนตัว'),
        ),
      ),
    ),
  );
}

Container changePassword(Function function) {
  return Container(
    // decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
    //   BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    // ]),
    child: Card(
      child: InkWell(
        onTap: () {
          function();
        },
        child: ListTile(
          leading: Icon(
            Icons.lock_outlined,
          ),
          title: Text('เปลี่ยนรหัส'),
        ),
      ),
    ),
  );
}

Container logout({Function function}) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    ]),
    child: Card(
      child: InkWell(
        onTap: () {
          function();
        },
        child: ListTile(
          leading: Icon(
            Icons.logout,
          ),
          title: Text('ออกจากระบบ'),
        ),
      ),
    ),
  );
}
