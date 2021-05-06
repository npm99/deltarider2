import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:deltarider2/api/api_data.dart';
import 'package:deltarider2/api/toJsonBanking.dart';
import 'package:deltarider2/api/toJsonReceiveOrders.dart';
import 'package:deltarider2/api/toJsonSlip.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:deltarider2/recieve/slip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../main_order.dart';

List listBanking;

class PaymentPage extends StatefulWidget {
  final BuildContext context;
  final ReceiveOrders data;

  const PaymentPage({Key key, this.context, this.data}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int tap = 0;
  bool show = false;
  int showIndex;
  var randomizer = new Random();

  void finishOrder(String orderID, BuildContext contextAlert) {
    String params = jsonEncode(<String, String>{'order_id': orderID});
    http
        .post('${Config.API_URL}/send_customer_order', body: params)
        .then((res) async {
      print(res.statusCode);
      print('order_id  $orderID');
      print(res.body);

      if (res.body == '1') {
        await databaseDelivery.set(randomizer.nextInt(100));
        databaseCustomer.child("$orderID").set(randomizer.nextInt(100));
        databaseRider.reference().child('$orderID').remove();
        loadLocation();
        showToastBottom(
          text: 'ส่งอาหารสำเร็จ',
          color: Colors.black.withOpacity(0.8),
        );
        Navigator.pop(context, 'ส่งอาหารสำเร็จ');
        Navigator.pop(contextAlert, 'ส่งอาหารสำเร็จ');
      } else {
        showToastBottom(
          text: 'ส่งอาหารไม่สำเร็จ',
          color: Colors.black.withOpacity(0.8),
        );
      }
    });
  }

  void paymentOrder(String orderID, BuildContext contextAlert) {
    String params = jsonEncode(<String, String>{
      'id_res_auto': token['data']['id_res_auto'],
      'amount': widget.data.sumPrice,
      'order_id': orderID,
      'admin_id': token['data']['admin_id']
    });
    http
        .post(
        '${Config.API_URL}/receive_money', body: params)
        .then((res) async {
      print(res.statusCode);
      print('order_id  $orderID');
      print(res.body);

      if (res.body == '1') {
        await databaseDelivery.set(randomizer.nextInt(100));
        databaseCustomer.child("$orderID").set(randomizer.nextInt(100));
        databaseRider.reference().child('$orderID').remove();
        loadLocation();
        showToastBottom(
          text: 'ส่งอาหารสำเร็จ',
          color: Colors.black.withOpacity(0.8),
        );
        Navigator.pop(context, 'ส่งอาหารสำเร็จ');
        Navigator.pop(contextAlert, 'ส่งอาหารสำเร็จ');
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
        builder: (BuildContext contextAlert) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text('ยืนยันการชำระเงิน'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ยกเลิก'),
                ),
                TextButton(
                    onPressed: () {
                      finishOrder(orderID, contextAlert);
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }

  Future _alertConfirmMoney(String orderID) async {
    return showDialog(
        context: context,
        builder: (BuildContext contextAlert) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text('ยืนยันการชำระเงิน'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ยกเลิก'),
                ),
                TextButton(
                    onPressed: () {
                      paymentOrder(orderID, contextAlert);
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.6,
      // Change as per your requirement
      width: MediaQuery
          .of(context)
          .size
          .width * 0.6,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Column(
        children: [
          ButtonTheme(
            buttonColor: Colors.black12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: ButtonBar(
              buttonMinWidth: 100,
              alignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  color: tap == 1 ? Colors.blue : null,
                  child: Text('โอนเงิน'),
                  onPressed: () {
                    setState(() {
                      tap = 1;
                    });
                  },
                ),
                RaisedButton(
                  color: tap == 2 ? Colors.blue : null,
                  child: Text('เงินสด'),
                  onPressed: () {
                    setState(() {
                      tap = 2;
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: tap == 0
                ? Container()
                : tap == 1
                ? page1()
                : page2(widget.data),
          ),
        ],
      ),
    );
  }

  Widget page1() {
    return Stack(
      children: [
        Container(
          // height: 600,
          // color: Colors.pink,
          child: ListView.builder(
              padding: EdgeInsets.only(top: 5, bottom: 60),
              itemCount: listBanking.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                Banking banking = listBanking[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    title: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ธนาคาร${banking.bank}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          show && showIndex == index
                              ? showBanking(banking)
                              : Container()
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        show = true;
                        showIndex = index;
                      });
                    },
                    // tileColor: Color.fromRGBO(0, 0, 0, 0.07),
                  ),
                );
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  color: Colors.green,
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt_outlined),
                      Text('  แนบสลิป'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SlipPage(data: widget.data)));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget showBanking(Banking banking) {
    return Container(
      // color: Colors.black12,
        margin: EdgeInsets.only(top: 10),
        child: banking.type2Options.isNotEmpty
            ? Column(
          children: [
            Image.network(banking.type2Options),
            Text(banking.acountName)
          ],
        )
            : Container(
          margin: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text("ชื่อบัญชี  ${banking.type1Options.name}"),
                Text('เลขบัญชี  ${banking.type1Options.number}'),
              ],
            ),
          ),
        ));
  }

  Widget page2(ReceiveOrders data) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 6, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ราคา  ',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '${data.sumPrice}  บาท',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
          RaisedButton(
              child: Text('ยืนยันการจ่ายเงิน'),
              onPressed: () {
                _alertConfirmMoney(widget.data.orderId);
              })
        ],
      ),
    );
  }
}
