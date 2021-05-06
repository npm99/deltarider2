import 'package:deltarider2/api/toJsonOrder.dart';
import 'package:deltarider2/api/toJsonReceiveOrders.dart';
import 'package:deltarider2/field/card_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BodyCardDetail extends StatefulWidget {
  final Orders dataOrder;
  final ReceiveOrders dataReceive;
  final dynamic snapshot;
  final String textPayment;
  final Widget widgetButton;

  BodyCardDetail(
      {Key key,
      this.dataOrder,
      this.snapshot,
      this.textPayment,
      this.dataReceive,
      this.widgetButton})
      : super(key: key);

  @override
  _BodyCardDetailState createState() => _BodyCardDetailState();
}

class _BodyCardDetailState extends State<BodyCardDetail> {
  String _status;
  String _giveaway;
  int click = 0;
  int count = 0;
  dynamic data;
  Widget widgetButton;

  @override
  Widget build(BuildContext context) {
    if (widget.dataOrder != null) {
      _status = widget.dataOrder.status;
      _giveaway = widget.dataOrder.memberGiveaway;
      data = widget.dataOrder;
    } else {
      _status = widget.dataReceive.status;
      _giveaway = widget.dataReceive.memberGiveaway;
      data = widget.dataReceive;
      widgetButton = widget.widgetButton;
    }

    return bodyCard(data, widget.snapshot, buttonReceive: widgetButton);
  }

  Widget bodyCard(data, snapshot, {Widget buttonReceive}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  data.member.picUrl,
                ),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '${data.member.mmName}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 0, 0, 0.65)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  buttonReceive == null
                      ? Container()
                      : buttonReceive
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'จัดส่ง :  ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 0.65)),
                  ),
                ]),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        //alignment: Alignment.centerLeft,
                        child: Text(
                      '${data.station.address}',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.65)),
                      //maxLines: 2,
                      overflow: click == 1 ? null : TextOverflow.ellipsis,
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
                data.comment == null || data.comment.isEmpty
                    ? Padding(padding: EdgeInsets.zero)
                    : Expanded(
                        flex: -1,
                        child: const Divider(
                          color: Colors.black12,
                          height: 20,
                          thickness: 2,
                        )),
                data.comment == null || data.comment.isEmpty
                    ? Padding(padding: EdgeInsets.zero)
                    : Row(
                        children: [
                          Text(
                            'comment :  ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 0.65)),
                          ),
                          Flexible(
                            child: Text(
                              '${data.comment}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(0, 0, 0, 0.65)),
                            ),
                          )
                        ],
                      ),
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
                      'รับช้อน :  ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 0.65)),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        //side: BorderSide(width: 5, color: Colors.green)
                      ),
                      color: _giveaway == '1' ? Colors.blue : Colors.black45,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        alignment: Alignment.center,
                        child: Text(
                          _giveaway == '1' ? 'รับช้อนส้อม' : 'ไม่รับช้อนส้อม',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    flex: -1,
                    child: const Divider(
                      color: Colors.black12,
                      height: 20,
                      thickness: 2,
                    )),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สถานะ :  ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 0.65)),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        //side: BorderSide(width: 5, color: Colors.green)
                      ),
                      color: _status == '4'
                          ? Colors.green
                          : Color.fromRGBO(0, 128, 96, 0.5),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        alignment: Alignment.center,
                        child: Text(
                          _status == '4' ? 'ทำอาหารเสร็จแล้ว' : 'กำลังทำอาหาร',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
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
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    //side: BorderSide(width: 5, color: Colors.green)
                  ),
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  color: data.paymentType == '0'
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
                        child: Text('${widget.textPayment}')),
                  ),
                ),
                cardMenuOrders(snapshot, data)
              ]),
        )
      ],
    );
  }
}
