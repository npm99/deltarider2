import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:deltarider2/api/toJsonLocation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class MessageLocation extends StatefulWidget {
  final Locations locations;

  MessageLocation({Key key, this.locations}) : super(key: key);

  @override
  _MessageLocationState createState() => _MessageLocationState();
}

class _MessageLocationState extends State<MessageLocation> {
  // Locations locations;
  //
  // _MessageLocationState(this.locations);

  List _listMessage;

  final GlobalKey scaffoldKeyAlert = new GlobalKey<ScaffoldState>();
  TextEditingController _message = TextEditingController();

  Future onSend(String memberID) async {
    String params = jsonEncode(
        <String, String>{"member_id": memberID, "message": _message.text});
    http.post('${Config.API_URL}/send_message', body: params).then((res) async {
      print(res.statusCode);
      print(memberID);
      print(_message.text);
      print(res.body);

      if (res.body == '1') {
        _message.clear();
      }
    });
  }

  void reloadMessage() async {
    //List list = await fetchMessage();
    // setState(() {
    //   _listMessage = list;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 204, 204, 255),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(
      extendBody: true,
      key: scaffoldKeyAlert,
      body: SingleChildScrollView(
        reverse: true,
        //padding: EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(bottom: 70, right: 5, left: 5),
          color: Colors.black.withAlpha(5),
          child: Column(
            children: [
              // Bubble(
              //   alignment: Alignment.center,
              //   color: Color.fromARGB(255, 212, 234, 244),
              //   elevation: 1 * px,
              //   margin: BubbleEdges.only(top: 8.0),
              //   child: Text('TODAY', style: TextStyle(fontSize: 10)),
              // ),
              Bubble(
                style: styleSomebody,
                child: Text(
                    'Hi Jason. Sorry to bother you. I have a queston for you.'),
              ),
              Bubble(
                style: styleMe,
                child: Text('Whats\'up?'),
              ),
              Bubble(
                style: styleSomebody,
                child: Text('I\'ve been having a problem with my computer.'),
              ),
              Bubble(
                style: styleSomebody,
                margin: BubbleEdges.only(top: 2.0),
                nip: BubbleNip.no,
                child: Text('Can you help me?'),
              ),
              Bubble(
                style: styleMe,
                child: Text('Ok'),
              ),
              Bubble(
                style: styleMe,
                nip: BubbleNip.no,
                margin: BubbleEdges.only(top: 2.0),
                child: Text('What\'s the problem?'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Container(
            color: Color.fromARGB(250, 224, 224, 224),
            //height: 100,
            padding: EdgeInsets.only(right: 5),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: new TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: _message,
                      autofocus: false,
                      style: new TextStyle(fontSize: 14.0),
                      decoration: new InputDecoration(
                        filled: true,
                        fillColor: Colors.white60,
                        hintText: 'กรอกข้อความ...',
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, right: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white60),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onSend(widget.locations.memberId);
                    print('send');
                  },
                  child: Icon(Icons.send_rounded, color: Colors.deepPurple),
                )
              ],
            )),
      ),
    );
  }
}
