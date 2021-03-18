import 'dart:convert';

import 'package:deltarider2/edit_data/change_password.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:deltarider2/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'api/infoDevice.dart';
import 'config.dart';
import 'field/onLoad.dart';
import 'main_order.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  void onLogout() {
    // onLoading(context);
    DeviceInfo deviceInfo = DeviceInfo.fromJson(deviceData);
    String params = jsonEncode(<String, dynamic>{
      'uuid': deviceInfo.uuid,
      'admin_id': token['data']['admin_id']
    });
    print(params);
    // print('${Config.API_URL}/logout');
    onLoading(context, _keyLoader);
    http.post('${Config.API_URL}/logout', body: params).then((value) async {
      print(value.body);
      if (value.body == '1') {
        //   dynamic _token = await FlutterSession().get('token');
        //   print(_token);
        // }
        await sharedPreferences.clear();
        // await FlutterSession().prefs.get('token').clear();
        Navigator.of(context).pop();
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
        // Navigator.of(context).pop();
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp()));
        // print('ddd');
      } else {
        showToastBottom(text: 'ออกจากระบบไม่สำเร็จ');
      }
    });
  }

  void onChangePassword() {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (BuildContext context) => new ChangePassword()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(token['data']['nick_name'].toString()),
          accountEmail: Text(token['data']['email'].toString()),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
            backgroundImage: token['data']['pro_file_url'] != ''
                ? NetworkImage(
                    '${token['data']['pro_file_url']}',
                    scale: 30,
                  )
                : AssetImage('assets/images/person_logo.png'),
          ),
        ),
        changePassword(onChangePassword),
        divider(),
        _logout(function: onLogout),
        divider(),
      ],
    );
  }
}

Divider divider() {
  return Divider(
    color: Colors.black38,
    height: 1,
    indent: 5,
    endIndent: 5,
  );
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
    decoration: BoxDecoration(border: Border(top: BorderSide.none)),
    child: ListTile(
      leading: Icon(
        Icons.lock_outline_rounded,
      ),
      title: Text('เปลี่ยนรหัส'),
      onTap: function,
    ),
  );
}

Container _logout({Function function}) {
  return Container(
    // decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
    //   BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    // ]),
    child: ListTile(
      leading: Icon(
        Icons.logout,
      ),
      title: Text('ออกจากระบบ'),
      onTap: function,
    ),
  );
}
