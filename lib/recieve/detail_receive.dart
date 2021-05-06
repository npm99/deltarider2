import 'dart:convert';

import 'package:deltarider2/api/api_data.dart';
import 'package:deltarider2/api/toJsonLocation.dart';
import 'package:deltarider2/api/toJsonReceiveOrders.dart';
import 'package:deltarider2/field/body.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:deltarider2/location/message.dart';
import 'package:deltarider2/main_order.dart';
import 'package:deltarider2/recieve/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../api/order_api.dart';
import 'dart:math' show Random;

import '../show_modal_app_map.dart';

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

  // List _listLocation;
  Locations locations;

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
        databaseCustomer.child("$orderID").set(randomizer.nextInt(100));
        databaseRider.reference().child('$orderID').remove();
        loadLocation();
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

  void loadData() async {
    List _list = await fetchLocation();
    List _listBanking = await loadBanking();
    // setState(() {
    //   _listLocation = _list;
    // });
    int index = _list.indexWhere((item) => item.orderId == widget.data.orderId);
    Locations _locations = _list[index];
    setState(() {
      locations = _locations;
      if (listBanking == null) {
        listBanking = _listBanking;
      }
    });
  }

  Future alertShipment(BuildContext context, ReceiveOrders data) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Text('เก็บเงินปลายทาง')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                )
              ],
            ),
            content: PaymentPage(
              context: context,
              data: widget.data,
            ),
          );
        });
  }

  @override
  void initState() {
    loadData();
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
      body: locations == null
          ? SpinKitRing(
              color: Colors.deepPurple[500],
              lineWidth: 5,
            )
          : FutureBuilder(
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
                            textPayment: _textPayment,
                            widgetButton: buttonReceive(),
                          ),
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
                  if (widget.data.paymentType == '0') {
                    alertShipment(context, widget.data)
                        .whenComplete(() => Navigator.of(context).pop());
                  } else {
                    _alertConfirm(widget.data.orderId);
                  }
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

  Future<void> callNow(String phone) async {
    String url = 'tel://${phone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'call not possible';
    }
  }

  Widget buttonReceive() {
    return ButtonBar(
      alignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      //buttonMinWidth: 100,
      children: [
        ClipOval(
          child: Material(
            color: Colors.blue[500], // button color
            child: InkWell(
              child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.navigation_rounded,
                    color: Colors.white,
                  )),
              onTap: () {
                openMapsSheet(context,
                    latLng: locations.location.lat,
                    lngLng: locations.location.lng);
              },
            ),
          ),
        ),
        ClipOval(
          child: Material(
            color: Colors.teal[300], // button color
            child: InkWell(
              child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 20,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MessageLocation(
                          locations: locations,
                        )));
              },
            ),
          ),
        ),
        locations.member.phoneId.isEmpty
            ? Padding(
                padding: EdgeInsets.zero,
              )
            : ClipOval(
                child: Material(
                  color: Colors.cyan[500], // button color
                  child: InkWell(
                    child: SizedBox(
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.local_phone_rounded,
                          color: Colors.white,
                          size: 20,
                        )),
                    onTap: () {
                      callNow(locations.member.phoneId);
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
