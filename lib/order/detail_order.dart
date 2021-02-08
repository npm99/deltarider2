import 'dart:convert';

import 'package:deltarider2/api/order_api.dart';
import 'package:deltarider2/api/toJsonOrder.dart';
import 'package:deltarider2/field/body.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:deltarider2/main_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show Random;

import '../config.dart';

class DetailOrder extends StatefulWidget {
  final Orders data;

  DetailOrder({Key key, this.data}) : super(key: key);

  _DetailOrder createState() => _DetailOrder();
}

class _DetailOrder extends State<DetailOrder> {
  // Orders data;
  //
  // _DetailOrder(this.data);

  GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  var randomizer = new Random();
  String _textPayment;

  void confirmOrder(String orderID, String riderId) {
    String params =
        jsonEncode(<String, String>{'order_id': orderID, 'rider': riderId});
    http.post('${Config.API_URL}/reseive', body: params).then((res) {
      print(res.body);
      if (res.body == '1') {
        databaseDelivery.set(randomizer.nextInt(100));
        Navigator.pop(context, 'รับงานสำเร็จ');
      }
    });
  }

  Future<void> _alertDialog(orderId) async {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: new Text(
                'ยืนยันรับงานนี้',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: new Text(
                'คุณไม่สามารถยกเลิกงานได้',
                style: TextStyle(color: Colors.black45),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ปิดออก')),
                TextButton(
                    onPressed: () async {
                      dynamic token = await FlutterSession().get('token');
                      confirmOrder(orderId, token['data']['admin_id']);
                      showToastBottom(
                        text: 'รับงานสำเร็จ',
                        color: Colors.black.withOpacity(0.8),
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      'รับงาน',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }

  @override
  void initState() {
    switch (widget.data.paymentType) {
      case "0":
        {
          _textPayment = 'เก็บเงินปลายทาง';
        }
        break;
      default:
        {
          _textPayment = 'โอนแล้ว';
        }
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Order ID : ${widget.data.orderIdRes}'),
      ),
      body: FutureBuilder(
        future: fetchDetailFood(widget.data.orderId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.only(top: 5),
              children: [
                Container(
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: -3)
                      ]),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: BodyCardDetail(
                        dataOrder: widget.data,
                        snapshot: snapshot,
                        textPayment: _textPayment),
                  ),
                ),
              ],
            );
          }
          return SpinKitRing(
            color: Colors.deepPurple[500],
            lineWidth: 5,
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  _alertDialog(widget.data.orderId);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.lightGreen, width: 2)),
                textColor: Colors.white,
                child: Text('รับงาน'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
