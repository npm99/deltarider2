import 'package:deltarider2/api/api_data.dart';
import 'package:deltarider2/api/toJsonHistory.dart';
import 'package:deltarider2/field/card_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'api/toJsonHistoryDetail.dart';

class HistoryDetailPage extends StatefulWidget {
  final HistoryDelivery data;

  const HistoryDetailPage({Key key, this.data}) : super(key: key);

  @override
  _HistoryDetailPageState createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  int count = 0, click;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Order ID : ${widget.data.orderIdRes}'),
      ),
      body: FutureBuilder(
        future: fetchHistoryDetail(widget.data.orderId),
        builder: (context, snapshot) {
          HistoryDetail data = snapshot.data;
          print(snapshot.error);
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'ไม่มีบิลนี้',
              style: TextStyle(fontSize: 20),
            ));
          }

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
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      //mainAxisAlignment: MainAxisAlignment.,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  widget.data.member.picUrl,
                                ),
                              ),
                              title: Text(
                                '${widget.data.member.mmName}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(0, 0, 0, 0.65)),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'จัดส่ง :  ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.65)),
                                      ),
                                    ]),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        //alignment: Alignment.centerLeft,
                                        child: Text(
                                      '${widget.data.address.address}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(0, 0, 0, 0.65)),
                                      //maxLines: 2,
                                      overflow: click == 1
                                          ? null
                                          : TextOverflow.ellipsis,
                                    )),
                                    InkWell(
                                      onTap: () {
                                        if (count == 0) {
                                          setState(() {
                                            click = 1;
                                            count++;
                                          });
                                        } else {
                                          setState(() {
                                            count = 0;
                                            click = 0;
                                          });
                                        }
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                // data.comment == null || data.comment.isEmpty
                                //     ? Padding(padding: EdgeInsets.zero)
                                //     : Expanded(
                                //     flex: -1,
                                //     child: const Divider(
                                //       color: Colors.black12,
                                //       height: 20,
                                //       thickness: 2,
                                //     )),
                                // data.comment == null || data.comment.isEmpty
                                //     ? Padding(padding: EdgeInsets.zero)
                                //     : Row(
                                //   children: [
                                //     Text(
                                //       'comment :  ',
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 16,
                                //           color: Color.fromRGBO(0, 0, 0, 0.65)),
                                //     ),
                                //     // Flexible(
                                //     //   child: Text(
                                //     //     '${data.comment}',
                                //     //     style: TextStyle(
                                //     //         fontSize: 16,
                                //     //         color: Color.fromRGBO(0, 0, 0, 0.65)),
                                //     //   ),
                                //     // )
                                //   ],
                                // ),
                                Expanded(
                                    flex: -1,
                                    child: const Divider(
                                      color: Colors.black12,
                                      height: 20,
                                      thickness: 2,
                                    )),
                                Row(
                                  children: [
                                    Text(
                                      'วันที่ :  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color.fromRGBO(0, 0, 0, 0.65)),
                                    ),
                                    Flexible(
                                        //alignment: Alignment.centerLeft,
                                        child: Text(
                                      '${data.date}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(0, 0, 0, 0.65)),
                                      //maxLines: 2,
                                      overflow: click == 1
                                          ? null
                                          : TextOverflow.ellipsis,
                                    )),
                                  ],
                                ),
                                Expanded(
                                    flex: -1,
                                    child: const Divider(
                                      color: Colors.black12,
                                      height: 20,
                                      thickness: 2,
                                    )),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    //side: BorderSide(width: 5, color: Colors.green)
                                  ),
                                  margin: EdgeInsets.only(top: 5, bottom: 10),
                                  color: widget.data.paymentType == '0'
                                      ? Colors.red[800].withOpacity(0.9)
                                      : Colors.green,
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: Text(
                                          widget.data.paymentType == '0'
                                              ? 'เก็บเงินปลายทาง'
                                              : 'โอนเงิน',
                                        )),
                                  ),
                                ),
                                Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.blue[300],
                                  child: Container(
                                      //color: Colors.green[300],
                                      alignment: Alignment.center,
                                      //padding: EdgeInsets.all(10),
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            //height: 200,
                                            //width: 500,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 5, 0),
                                            //color: Colors.white24,
                                            child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: data.data.length,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        index) {
                                                  Datum detail =
                                                      data.data[index];
                                                  // _comment = detail.comment;
                                                  return DefaultTextStyle(
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Kanit',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                                fit: FlexFit
                                                                    .tight,
                                                                child: Text(
                                                                  'x${detail.number}   ${detail.text}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )),
                                                            Text(
                                                                '${detail.sum.split('.').first} บาท '),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            detail.comment
                                                                    .isEmpty
                                                                ? Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero)
                                                                : Text(
                                                                    '- ${detail.comment}'),
                                                          ],
                                                        ),
                                                        Expanded(
                                                            flex: 0,
                                                            child:
                                                                const Divider(
                                                              color: Colors
                                                                  .white54,
                                                              thickness: 1,
                                                            )),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                          DefaultTextStyle(
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 17,
                                                  fontFamily: 'Kanit',
                                                  fontWeight: FontWeight.w600),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 5, 10),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.9),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'ค่าอาหารรวม :  '),
                                                          Text(
                                                              '${int.parse(widget.data.priceFood) - int.parse(widget.data.priceSend)} บาท '),
                                                        ]),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('ค่าจัดส่ง :  '),
                                                          Text(
                                                              '${widget.data.priceSend} บาท ')
                                                        ]),
                                                    Expanded(
                                                        flex: 0,
                                                        child: const Divider(
                                                          color: Colors.black26,
                                                          thickness: 1,
                                                        )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('ราคารวม :  '),
                                                        Text(
                                                            '${data.sumPrice} บาท ')
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      )),
                                )
                              ]),
                        )
                      ],
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
      //
    );
    ;
  }
}
