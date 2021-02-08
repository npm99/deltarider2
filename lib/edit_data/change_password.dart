import 'dart:convert';

import 'package:deltarider2/config.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _current = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onClick() async {
    dynamic token = await FlutterSession().get('token');
    String adminID = token['data']['admin_id'];

    String params = jsonEncode(<String, String>{
      'admin_id': adminID,
      'password': _current.text,
      'new_password': _newPassword.text
    });
    await http.post('${Config.API_URL}/change_pass', body: params).then((res) {
      print(res.body);
      int resData = jsonDecode(res.body);
      if (resData == 0) {
        showToastBottom(
          text: 'รหัสผ่านเดิมไม่ถูกต้อง',
          color: Colors.black.withOpacity(0.8),
        );
      } else {
        _current.clear();
        _newPassword.clear();
        _confirmPassword.clear();
        showToastBottom(
          text: 'เปลี่ยนรหัสสำเร็จ',
          color: Colors.black.withOpacity(0.8),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เปลี่ยนรหัสผ่าน'),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(children: [
                TextFormField(
                  controller: _current,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'รหัสผ่านเดิม'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'โปรดกรอกรหัสผ่านเดิม';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPassword,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'รหัสผ่านใหม่',
                      hintText: 'รหัสผ่านไม่ต่ำกว่า 5 ตัว'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'โปรดกรอกรหัสผ่านใหม่';
                    } else if (value.length < 6) {
                      return 'รหัสผ่านต้องมากกว่า 5 ตัว';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPassword,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'ยืนยันรหัสผ่าน',
                      hintText: 'รหัสผ่านไม่ต่ำกว่า 5 ตัว'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'โปรดกรอกยืนยันรหัสผ่าน';
                    }
                    print(_newPassword.text);
                    print(_confirmPassword.text);

                    if (_newPassword.text != _confirmPassword.text) {
                      return 'รหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 150,
              height: 40,
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  _formKey.currentState.validate();
                  onClick();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.lightGreen, width: 2)),
                textColor: Colors.white,
                child: Text('ยืนยัน'),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
