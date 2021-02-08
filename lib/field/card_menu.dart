import 'package:deltarider2/api/toJsonDetailFood.dart';
import 'package:deltarider2/api/toJsonOrder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String _comment;

Widget cardMenuOrders(snapshot,data,){
  return  Card(
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
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder:
                      (BuildContext context,
                      index) {
                    DetailFood detail =
                    snapshot.data[index];
                    _comment = detail.comment;
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
                                    'x${detail.count}   ${detail.name}',
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                  )),
                              Text(
                                  '${detail.price} บาท '),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              _comment.isEmpty
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
                                '${data.priceFood} บาท '),
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
                                '${data.priceSend} บาท ')
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
  );
}
