import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main_order.dart';

  void showToastBottom({String text, Color color, int time, Color textColor}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor == null ? Colors.white : textColor),
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: time != null ? time : 2),
        //gravity: ToastGravity.BOTTOM,
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: 70,
            left: 24,
            right: 24,
          );
        });
  }

  // showToastCenter({String text, Color color, int time, Color textColor}) {
  //   Widget toast = Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       color: color,
  //     ),
  //     child: Text(
  //       text,
  //       style: TextStyle(color: textColor == null ? Colors.white : textColor),
  //     ),
  //   );
  //
  //   fToast.showToast(
  //       child: toast,
  //       toastDuration: Duration(seconds: time != null ? time : 2),
  //       // gravity: ToastGravity.CENTER,
  //       positionedToastBuilder: (context, child) {
  //         return Positioned(
  //           child: child,
  //           top: MediaQuery.of(context).size.height - 300,
  //           left: 24,
  //           right: 24,
  //         );
  //       });
  // }
