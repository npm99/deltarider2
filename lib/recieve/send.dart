import 'dart:async';

import 'package:deltarider2/recieve/detail_receive.dart';
import 'package:flutter/cupertino.dart';
import '../api/toJsonLocation.dart';
import '../api/toJsonReceiveOrders.dart';
import 'package:flutter/material.dart';
import 'package:deltarider2/api/order_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:deltarider2/main_order.dart';

List listLocation = [];
class Send extends StatefulWidget {
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  Stream _stream;
  String _status;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> checkReceiveOrders() async {
    if (listLocation.isNotEmpty) {
      for (int i = 0; i < listLocation.length; i++) {
        Locations locationsData = listLocation[i];
        databaseRider
            .reference()
            .child(locationsData.orderId)
            .set({'lat': position.latitude, 'lng': position.longitude});
      }
      print('check Location');
    }
  }

  Future refresh() async {
    setState(() {
      _stream = databaseDelivery.onValue
          .asyncExpand((event) => getReceiveOrders());
    });
  }

  @override
  void initState() {
    _stream =
        databaseDelivery.onValue.asyncExpand((event) => getReceiveOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        // appBar: new AppBar(
        //   centerTitle: true,
        //   title: Text('การจัดส่ง',style: TextStyle(fontWeight: FontWeight.bold),),
        //   toolbarHeight: 50,
        // ),
        // drawer: Drawer(
        //   child: MenuList(),
        // ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      ReceiveOrders order = snapshot.data[index];
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
                                        ReceiveDetail(snapshot.data[index])));
                            print('aaa');
                          },
                          child: Card(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(20.0),
                            // ),
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
                                        //crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'เวลาสั่ง ${order.timeStart}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  tileColor: Colors.black12,
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
                                            //width: 210,
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
                                              translation: Offset(0.1, 0.3),
                                              child: Text(
                                                '${order.station.duration} ( ${order.station.distance})',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            FractionalTranslation(
                                              translation: Offset(0.2, 0.3),
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
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
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

Container listMenu() {
  return Container(
    //padding: EdgeInsets.only(bottom: 10),
    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
        ]),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: const Text(
              '224 bath',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            tileColor: Colors.black12,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          //Image.asset('assets/images/logo.jpg'),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              OutlineButton(
                padding: EdgeInsets.only(left: 40, right: 40),
                focusColor: Colors.deepPurple,
                shape: StadiumBorder(),
                textColor: Colors.green,
                highlightedBorderColor: Colors.green,
                highlightColor: Colors.green[100],
                child: Text('รับงาน'),
                borderSide: BorderSide(
                    color: Colors.green, style: BorderStyle.solid, width: 1),
                onPressed: () {
                  print('รับงาน');
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
