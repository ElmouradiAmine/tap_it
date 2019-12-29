import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  Widget customButton(String text, Color color, Function function) {
    return RaisedButton(
      onPressed: function,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: color,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                FlutterLogo(
                  size: 200,
                ),
                Text("Check how fast you can type !"),
                SizedBox(
                  height: height/8,
                ),
                customButton("1 player", Colors.green, () {}),
                SizedBox(
                  height: height/20,
                ),
                customButton("2 player", Colors.red, () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
