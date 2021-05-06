import 'dart:convert';
import 'dart:math';

import 'package:deltarider2/api/toJsonReceiveOrders.dart';
import 'package:deltarider2/api/toJsonSlip.dart';
import 'package:deltarider2/field/showtoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../main_order.dart';

class SlipPage extends StatefulWidget {
  final ReceiveOrders data;

  const SlipPage({Key key, this.data}) : super(key: key);

  @override
  _SlipPageState createState() => _SlipPageState();
}

List<Slip> listPhoto;

class _SlipPageState extends State<SlipPage> {
  File file;
  String base64Image;
  TextEditingController amount = TextEditingController();
  var randomizer = new Random();
  final _formKey = GlobalKey<FormState>();

  void showImage() {
    if (file == null) return;
    List<int> imageBytes = file.readAsBytesSync();
    String fileName = file.path.split(".").last;
    base64Image = '$fileName;${base64Encode(imageBytes)}';

    print(base64Image);
    amount.text = widget.data.sumPrice;
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('จำนวนเงิน'),
              content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'โปรดกรอกตัวเลข';
                      }
                      return null;
                    },
                  )),
              actions: [
                TextButton(
                    child: Text(
                      'ปิดออก',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        String params = jsonEncode(<String, String>{
                          'id_res_auto': token['data']['id_res_auto'],
                          'slip': base64Image,
                          'id_pay_type': widget.data.paymentType,
                          'amount': amount.text,
                          'order_id': widget.data.orderId,
                        });

                        http
                            .post('${Config.API_URL}/upload_slip', body: params)
                            .then((res) async {
                          print(res.statusCode);
                          // print('order_id  $orderID');

                          List list = slipFromJson(res.body);
                          setState(() {
                            listPhoto = list;
                          });
                          amount.clear();
                          Navigator.of(context).pop();
                          print(res.body);
                        });
                      }
                    }),
              ],
            ));
  }

  Future getImage() async {
    var _file = await ImagePicker().getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (_file == null) return;
    setState(() {
      file = File(_file.path);
    });
    print(file);

    showImage();
  }

  Future onDelete(String idSlip) async {
    String params = jsonEncode(<String, String>{
      'id_slip': idSlip,
      'id_res_auto': token['data']['id_res_auto'],
      'order_id': widget.data.orderId
    });
    http.post('${Config.API_URL}/remove_slip', body: params).then((value) {
      print(value.body);
      if (value.body == '1') {
        setState(() {
          listPhoto.removeWhere((element) => element.idSlip == idSlip);
        });

        showToastBottom(text: 'ลบสำเร็จ');
      } else {
        showToastBottom(text: 'ลบไม่สำเร็จ');
      }
    });
  }

  void onClick() {
    String params = jsonEncode(<String, String>{
      'id_res_auto': token['data']['id_res_auto'],
      'order_id': widget.data.orderId
    });
    http.post('${Config.API_URL}/add_noti', body: params).then((value) {
      print(value.body);

      databaseNoti.set(randomizer.nextInt(100));
      showToastBottom(text: 'ยืนยันสำเร็จ');
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      listPhoto = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แนบสลิป'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: listPhoto == null
                ? Container()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    itemCount: listPhoto.length,
                    itemBuilder: (context, index) {
                      Slip slip = listPhoto[index];
                      // print(slip.imgUrl);
                      return Container(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 140,
                                height: 140,
                                child: Image.network(slip.imgUrl)),
                            Text(
                              '${slip.amount} บาท',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            RaisedButton(
                              color: Colors.red.shade700,
                              onPressed: () {
                                onDelete(slip.idSlip);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              textColor: Colors.white,
                              child: Text('ลบ'),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        // color: Colors.deepPurple,
                      );
                    }),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                  child: Text('เลือกรูปสลิป'),
                  onPressed: () {
                    getImage();
                  }),
              RaisedButton(
                  child: Text('ยืนยันการชำระเงิน'),
                  onPressed: () {
                    onClick();
                  }),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
