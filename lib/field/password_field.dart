import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final Icon fieldIconPass;
  final String hintTextPass;
  final Function function;

  final TextEditingController passWord;

  PasswordField(this.fieldIconPass, this.hintTextPass, this.passWord, this.function);

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
            Padding(
                padding: const EdgeInsets.only(left: 12), child: fieldIconPass),
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
                    onChanged: (val){function();},
                    obscureText: true,
                    controller: passWord,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintTextPass,
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
