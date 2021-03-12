import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:deltarider2/api/api_data.dart';
import 'package:deltarider2/api/toJsonLocation.dart';
import 'package:deltarider2/api/toJsonMessage.dart';
import 'package:deltarider2/location/bubbleChat.dart';
import 'package:deltarider2/main_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class MessageLocation extends StatefulWidget {
  final Locations locations;

  MessageLocation({Key key, this.locations}) : super(key: key);

  @override
  _MessageLocationState createState() => _MessageLocationState();
}

class _MessageLocationState extends State<MessageLocation> {
  Stream stream;
  var randomizer = new Random();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey scaffoldKeyAlert = new GlobalKey<ScaffoldState>();
  TextEditingController _message = TextEditingController();

  Future onSend(String memberID) async {
    print('member_$memberID');
    String params = jsonEncode(
        <String, String>{"mm_id": memberID, "message": _message.text});
    http.post('${Config.API_URL}/send_message', body: params).then((res) async {
      print(res.statusCode);
      print(res.body);
      if (res.body == '1') {
        _message.clear();
        databaseChat.child('member_$memberID').set(randomizer.nextInt(100));
        loadMessage();
      }
    });
  }

  void loadMessage() async {
    Stream _stream = databaseChat.reference().child('member_${widget.locations.memberId}').onValue
        .asyncExpand((event) => getChet(widget.locations.memberId));
    setState(() {
      stream = _stream;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadMessage();
    databaseChat.reference().child('member_${widget.locations.memberId}').onValue.listen((event) {

        print('${event.snapshot.value}');
      });
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   databaseChat.onValue.listen((event) {
  //     print('MM '+event.snapshot.value);
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    return Scaffold(
      key: scaffoldKeyAlert,
      // backgroundColor: Colors.white,
      //extendBody: true,
      appBar: AppBar(
        title: Text(widget.locations.member.mmName),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
              //margin: EdgeInsets.only(bottom: 5, right: 5, left: 5),
              color: Colors.black.withAlpha(5),
              child: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 100),
                        );
                      } else {
                        setState(() => null);
                      }
                    });
                    if (snapshot.hasData) {
                      // print(snapshot.data.length);
                      if (snapshot.data.length == 0) {
                        return Center(
                          child: Text('ไม่มีข้อความ'),
                        );
                      }
                      return ListView.builder(
                          controller: _scrollController,
                          //reverse: true,
                          padding: EdgeInsets.only(bottom: 70),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, index) {
                            ChatUser chat = snapshot.data[index];

                            if (chat.byUser == '0') {
                              return chatAdminBubble(context,
                                  px: px,
                                  locations: widget.locations,
                                  chat: snapshot.data[index]);
                            }
                            //styleUser
                            return chatUserBubble(context,
                                px: px,
                                locations: widget.locations,
                                chat: snapshot.data[index]);
                          });
                    }
                    return SpinKitRing(
                      color: Colors.deepPurple[500],
                      lineWidth: 5,
                    );
                  })),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
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
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 7),
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
                                borderSide:
                                    new BorderSide(color: Colors.white60),
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
                        child:
                            Icon(Icons.send_rounded, color: Colors.deepPurple),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
