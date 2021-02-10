import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:deltarider2/api/toJsonLocation.dart';
import 'package:deltarider2/api/toJsonMessage.dart';
import 'package:deltarider2/show_modal_app_map.dart';
import 'package:flutter/material.dart';

Widget widgetBubble;

void checkType(ChatUser chat, context) {
  double width = MediaQuery.of(context).size.width;
  if (chat.chatText.type == null) {
    widgetBubble = Text('${chat.chatText.message.text}');
  }
  switch (chat.chatText.type) {
    case 'text':
      {
        widgetBubble = Text(chat.chatText.text);
      }
      break;
    case "location":
      {
        widgetBubble = InkWell(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/map.png',
                scale: 4,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10),
                  width: width - 170,
                  child: Text(
                    '${chat.chatText.address}',
                  )),
            ],
          ),
          onTap: () {
            print('map');
            openMapsMark(context, chat.chatText.address,
                latLng: chat.chatText.latitude,
                lngLng: chat.chatText.longitude);
          },
        );
      }
      break;
    case "sticker":
      {
        String url =
            'https://stickershop.line-scdn.net/stickershop/v1/sticker/${chat.chatText.stickerId}/ANDROID/sticker.png';
        widgetBubble = Image.network(
          url,
          scale: 1.5,
        );
      }
      break;
    case "image":
      {
        widgetBubble = Image.network(
          chat.chatText.url,
          scale: 4,
        );
      }
      break;
  }
}

Widget chatAdminBubble(BuildContext context,
    {@required px, @required Locations locations, @required ChatUser chat}) {
  BubbleStyle styleMe = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: Color.fromARGB(255, 204, 204, 255),
    elevation: 1 * px,
    margin: BubbleEdges.only(top: 20.0, left: 50.0, right: 3),
    alignment: Alignment.topRight,
  );
  checkType(chat, context);
  return Bubble(
    style: styleMe,
    child: widgetBubble,
  );
}

Widget chatUserBubble(BuildContext context,
    {@required px, @required Locations locations, @required ChatUser chat}) {
  BubbleStyle styleSomebody = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: Colors.white,
    elevation: 1 * px,
    margin: BubbleEdges.only(top: 20.0, right: 50.0),
    alignment: Alignment.topLeft,
  );
  checkType(chat, context);
  String type = chat.chatText.type;

  return Row(
    //mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 7),
        child: CircleAvatar(
          backgroundImage: NetworkImage(locations.member.picUrl),
        ),
      ),
      type == "sticker"
          ? Container(
              margin: const EdgeInsets.only(top: 20.0, right: 50.0),
              child: widgetBubble,
            )
          : Bubble(
              style: styleSomebody,
              child: widgetBubble,
            ),
    ],
  );
}
