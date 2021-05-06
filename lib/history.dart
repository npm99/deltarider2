import 'package:deltarider2/api/api_data.dart';
import 'package:deltarider2/api/toJsonHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'history_detail.dart';

List<HistoryDelivery> deliveryHistory;

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime _dateTime = new DateTime.now();
  int sumPriceData = 0, selectIndex;
  bool click = false;

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat dateFormatA = DateFormat('yyyy-MM-dd');

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(_dateTime.year - 10),
        lastDate: DateTime(_dateTime.year + 5));

    if (picked != null && picked != _dateTime) {
      //print('วันที่ : ${_dateTime.toString()}');
      setState(() {
        _dateTime = picked;
        // print(dateFormatA.format(_dateTime.));
      });
      if (picked != null) {
        List<HistoryDelivery> list =
            await fetchHistory(dateFormatA.format(picked).toString());
        sumPriceData = 0;
        click = false;
        setState(() {
          deliveryHistory = list;
          list.forEach((element) {
            if (element.paymentType == '0') {
              sumPriceData += int.parse(element.sumPrice);
            }
          });
        });
      }
    }
  }

  void loadDeliveryHistory() async {
    // if (deliveryHistory == null) {
    sumPriceData = 0;

    List list = await fetchHistory(dateFormatA.format(_dateTime).toString());
    setState(() {
      deliveryHistory = list;
      list.forEach((element) {
        if (element.paymentType == '0') {
          sumPriceData += int.parse(element.sumPrice);
        }
      });
    });
    // }
  }

  @override
  void initState() {
    loadDeliveryHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
        child: Column(
          children: [
            Container(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(top: 18),
                      child: Text('ยอดเงินสด  $sumPriceData บาท'),
                    ),
                    Container(
                        child: InkWell(
                      onTap: () async {
                        selectDate(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            dateFormat.format(_dateTime),
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          Icon(
                            Icons.date_range_sharp,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: deliveryHistory == null
                  ? SpinKitRing(
                      color: Colors.deepPurple[500],
                      lineWidth: 5,
                    )
                  : ListView.builder(
                      // padding: EdgeInsets.only(top: 5),
                      itemCount: deliveryHistory.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        HistoryDelivery delivery = deliveryHistory[index];
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HistoryDetailPage(
                                            data: delivery,
                                          )));
                              // setState(() {
                              //   click = true;
                              //   selectIndex = index;
                              // });
                            },
                            child: Card(
                              // color: Colors.blueGrey[50],
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Material(
                                          //   borderRadius:
                                          //       BorderRadius.all(
                                          //           Radius.circular(20)),
                                          //   child: CircleAvatar(
                                          //     radius: 20,
                                          //     backgroundColor:
                                          //         Colors.blueGrey[300],
                                          //     child: Icon(Icons.),
                                          //   ),
                                          // ),
                                          Container(
                                            // padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Order ID: ${delivery.orderIdRes}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),

                                          Column(
                                            children: [
                                              Text(
                                                'ราคารวม ${delivery.sumPrice} บาท',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              FractionalTranslation(
                                                translation: Offset(0.2, 0.3),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    30)),
                                                    //side: BorderSide(width: 5, color: Colors.green)
                                                  ),
                                                  color: delivery.paymentType ==
                                                          '0'
                                                      ? delivery.status == '1'
                                                      ? Colors.green
                                                      : delivery.status == '2'
                                                      ? Colors.red.shade700
                                                      : Colors.black45
                                                      : Colors.indigoAccent,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2,
                                                            horizontal: 30),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      delivery.paymentType == '0'
                                                          ? delivery.status == '1'
                                                              ? ' เสร็จสิ้น'
                                                              : delivery.status == '2'
                                                                  ? 'ยังไม่ส่งเงิน'
                                                                  : 'ยกเลิก'
                                                          : '    โอนเงิน   ',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    tileColor: Color.fromRGBO(0, 0, 0, 0.07),
                                  ),
                                  click && selectIndex == index
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15,
                                              left: 10,
                                              right: 10,
                                              bottom: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ส่งที่ ${delivery.address.address}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                // style: TextStyle(
                                                //   color:
                                                //       Colors.black.withOpacity(0.6),
                                                // )
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'การชำระเงิน    ',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      // style: TextStyle(
                                                      //   color:
                                                      //       Colors.black.withOpacity(0.6),
                                                      // )
                                                    ),
                                                    Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        //side: BorderSide(width: 5, color: Colors.green)
                                                      ),
                                                      color: delivery
                                                                  .paymentType ==
                                                              '0'
                                                          ? Colors.red.shade700
                                                          : Colors.green,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2,
                                                                horizontal: 6),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          delivery.paymentType ==
                                                                  '0'
                                                              ? 'เก็บเงินปลายทาง'
                                                              : 'โอนเงิน',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
