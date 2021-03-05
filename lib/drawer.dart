import 'package:deltarider2/edit_data/change_password.dart';
import 'package:deltarider2/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'config.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  void onLogout() {
    FlutterSession().set('token', '');
    Navigator.of(context).pop();
    Navigator.push(context,
        new CupertinoPageRoute(builder: (BuildContext context) => new MyApp()));
  }

  void onChangePassword() {
    Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (BuildContext context) => new ChangePassword()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FlutterSession().get('token'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic data = snapshot.data;
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(data['data']['nick_name'].toString()),
                  accountEmail: Text(data['data']['email'].toString()),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? Colors.blue
                            : Colors.white,
                    backgroundImage: data['data']['pro_file_url'] != ''
                        ? NetworkImage(
                            '${data['data']['pro_file_url']}',
                            scale: 30,
                          )
                        : AssetImage('assets/images/person_logo.png'),
                  ),
                ),
                changePassword(onChangePassword),
                divider(),
                logout(function: onLogout),
                divider(),
              ],
            );
          }
          return SpinKitRing(
            color: Colors.deepPurple[500],
            lineWidth: 5,
          );
        });
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

Container logout({Function function}) {
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
