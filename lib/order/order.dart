import 'dart:async';
import 'dart:convert';
import 'dart:math' show Random;

import 'package:deltarider2/config.dart';
import 'package:deltarider2/api/order_api.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:deltarider2/recieve/send.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'detail_order.dart';
import '../api/toJsonOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:deltarider2/main_order.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  var randomizer = new Random();
  Stream _stream;
  String _status;
  int count = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _alertDialog(orderId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: new Text('ยืนยันรับงานนี้'),
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
                      Navigator.pop(context, 'รับงานสำเร็จ');
                    },
                    child: Text(
                      'รับงาน',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }

  void confirmOrder(String orderID, String riderId) {
    String params =
        jsonEncode(<String, String>{'order_id': orderID, 'rider': riderId});
    http.post('${Config.API_URL}/reseive', body: params).then((res) {
      print(res.body);

      if (res.body == '1') {
        databaseDelivery.set(randomizer.nextInt(100));
        showToastBottom(
            text: 'รับงานสำเร็จ', color: Colors.black.withOpacity(0.8));
      } else {
        showToastBottom(
            text: 'รับงานไม่สำเร็จ', color: Colors.black.withOpacity(0.8));
      }
    });
  }

  Future<Null> _handleLoad() async {
    setState(() {
      _stream = databaseDelivery.onValue.asyncExpand((event) => getOrders());
    });
    //return null;
  }

  Future<void> loadLocation() async {
    listLocation = await fetchLocation();
    print('load Location');
  }

  @override
  void initState() {
    _stream = databaseDelivery.onValue.asyncExpand((event) => getOrders());
    getOrders();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //---------------------------------------------------------
    databaseRider.onValue.listen((event) {
      print('key  ${event.snapshot.key}');
      print('value  ${event.snapshot.value}');
    });
    //---------------------------------------------------------
    Timer.periodic(Duration(seconds: 15),
        (Timer t) => Send().createState().checkReceiveOrders());
    //-------------------------------------------------
    databaseDelivery.onValue.listen((event) {
      loadLocation();
      print(event.snapshot.key);
      print(event.snapshot.value);
    });
    //--------------------------------------------------------
    MyHomePage().createState().notify().asStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        // appBar: new AppBar(
        //   centerTitle: true,
        //   title: Text('ออร์เดอร์', style: TextStyle(fontWeight: FontWeight.bold)),
        //   toolbarHeight: 50,
        // ),

        body: RefreshIndicator(
          onRefresh: _handleLoad,
          child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      Orders order = snapshot.data[index];
                      _status = order.status;
                      return Container(
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: -3)
                            ]),
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailOrder(
                                            data: snapshot.data[index])));
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      order.member.picUrl,
                                      scale: 12,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ID : ${order.orderIdRes}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${order.timeStart}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'ระยะทาง : ${order.station.distance}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  tileColor: Color.fromRGBO(0, 0, 0, 0.07),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 15,
                                    left: 15,
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            //width: 200,
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${order.station.address}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                )),
                                          ],
                                        )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            FractionalTranslation(
                                              translation: Offset(0.1, 0.1),
                                              child: OutlineButton(
                                                focusColor: Colors.deepPurple,
                                                shape: StadiumBorder(),
                                                textColor: Colors.green,
                                                highlightedBorderColor:
                                                    Colors.green,
                                                highlightColor:
                                                    Colors.green[100],
                                                child: Text('รับงาน'),
                                                borderSide: BorderSide(
                                                    color: Colors.green,
                                                    style: BorderStyle.solid,
                                                    width: 1),
                                                onPressed: () async {
                                                  print('รับงาน');
                                                  _alertDialog(order.orderId);
                                                },
                                              ),
                                            ),
                                            FractionalTranslation(
                                              translation: Offset(0.2, 0.2),
                                              child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    30)),
                                                  ),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    height: 20,
                                                    color: _status == '4'
                                                        ? Colors.green
                                                        : Colors.black54,
                                                    child: Text(
                                                      _status == '4'
                                                          ? 'เสร็จแล้ว'
                                                          : 'ยังไม่เสร็จ',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return SpinKitRing(
                  color: Colors.deepPurple[500],
                  lineWidth: 5,
                );
              }),
        ));
  }
}
