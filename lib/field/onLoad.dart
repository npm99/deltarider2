import 'dart:convert';

import 'package:deltarider2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:deltarider2/api/order_api.dart';
// import 'package:flutter_session/flutter_session.dart';

import '../main_order.dart';

Future<void> onLoading(BuildContext context, GlobalKey key) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          key: key,
          // color: Colors.white,
          child: SpinKitRing(
            color: Colors.deepPurple[500],
            lineWidth: 5,
          ),
        );
      });
}

Future<void> setNode() async {
  token = jsonDecode(sharedPreferences.getString('token'));
  id = token['data']['id_res_auto'];
  code = token['data']['code'];
  print(token);
  databaseReference = firebaseDatabase.reference().child('${id}_${code}');

  databaseDelivery =
      firebaseDatabase.reference().child('${id}_${code}/delivery');

  databaseAddDelivery =
      firebaseDatabase.reference().child('${id}_${code}/add_delivery');

  databaseRider = firebaseDatabase.reference().child('${id}_${code}/rider');
  databaseChat = firebaseDatabase.reference().child('${id}_${code}/chat');
}
