import 'package:flutter/material.dart';

class UserField extends StatelessWidget {
  final Icon fieldIcon;
  final String hintText;
  final Function function;

  final TextEditingController _userName;

  UserField(this.fieldIcon, this.hintText, this._userName, this.function);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: const EdgeInsets.only(left: 12), child: fieldIcon),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                width: 200,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    onChanged: (val) {
                      function();
                    },
                    controller: _userName,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        fillColor: Colors.white,
                        filled: true),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
