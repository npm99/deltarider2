import 'dart:convert';

import 'package:deltarider2/api/toJsonReceiveOrders.dart';
import 'package:deltarider2/field/body.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:deltarider2/main_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../api/order_api.dart';
import 'dart:math' show Random;

class ReceiveDetail extends StatefulWidget {
  final ReceiveOrders data;

  ReceiveDetail(this.data);

  _ReceiveDetail createState() => _ReceiveDetail();
}

class _ReceiveDetail extends State<ReceiveDetail> {
  // ReceiveOrders data;
  //
  // _ReceiveDetail(this.data);

  GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  var randomizer = new Random();
  String _textPayment;

  void finishOrder(String orderID) {
    String params = jsonEncode(<String, String>{'order_id': orderID});
    http
        .post('${Config.API_URL}/send_customer_order', body: params)
        .then((res) async {
      print(res.statusCode);
      print('order_id  $orderID');
      print(res.body);

      if (res.body == '1') {
        await databaseDelivery.set(randomizer.nextInt(100));
        databaseRider.reference().child('$orderID').remove();
        showToastBottom(
          text: 'ส่งอาหารสำเร็จ',
          color: Colors.black.withOpacity(0.8),
        );
        Navigator.pop(context, 'ส่งอาหารสำเร็จ');
      } else {
        showToastBottom(
          text: 'ส่งอาหารไม่สำเร็จ',
          color: Colors.black.withOpacity(0.8),
        );
      }
    });
  }

  Future _alertConfirm(String orderID) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text('ยืนยันการส่งออร์เดอร์'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ยกเลิก'),
                ),
                TextButton(
                    onPressed: () {
                      finishOrder(orderID);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'ยืนยัน',
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
            return ListView(padding: EdgeInsets.only(top: 5), children: [
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
                        dataReceive: widget.data,
                        snapshot: snapshot,
                        textPayment: _textPayment),
                  )),
            ]);
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
                  _alertConfirm(widget.data.orderId);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.lightGreen, width: 2)),
                textColor: Colors.white,
                child: Text('ส่งให้ลูกค้าแล้ว'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
