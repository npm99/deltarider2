import 'package:deltarider2/config.dart';
import 'package:deltarider2/menu_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(top: 45, bottom: 10),
            centerTitle: true,
            title: userProfile(),
          ),
        ),
        body: MenuList(),
      ),
    );
  }
}

FutureBuilder userProfile() {
  return FutureBuilder(
      future: FlutterSession().get('token'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dynamic data = snapshot.data;
          return Container(
            width: 300,
            child: new Stack(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 30,
                  child: Container(
                    width: 400,
                    padding: EdgeInsets.only(top: 30, bottom: 15, left: 100),
                    child: DefaultTextStyle(
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.hasData
                                  ? data['data']['nick_name'].toString()
                                  : 'Loading...'),
                              Text(snapshot.hasData
                                  ? data['data']['email'].toString()
                                  : 'Loading...'),
                            ])),
                  ),
                ),
                FractionalTranslation(
                  translation: Offset(0.0, -0.1),
                  child: Align(
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      radius: 40.0,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: NetworkImage(
                          '${Config.URL_PHOTO}/${data['data']['pro_file_url']}',
                          scale: 30,
                        ),
                      ),
                    ),
                    alignment: FractionalOffset(0.05, 0.7),
                  ),
                ),
              ],
            ),
          );
        }
        return SpinKitRing(
          color: Colors.deepPurple[500],
          lineWidth: 5,
        );
      });
}
