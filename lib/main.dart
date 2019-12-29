import 'package:flutter/material.dart';
import 'package:tap_it/pages/menu_page.dart';
import 'pages/two_player_page.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {

      },
      debugShowCheckedModeBanner: false,
      home: MenuPage(),
    );
  }
}
