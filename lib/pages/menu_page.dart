import 'package:flutter/material.dart';
import 'package:tap_it/pages/one_player_page.dart';
import 'package:tap_it/pages/two_player_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
//this will start the animation
    controller.forward();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: height / 24,
            ),
            Stack(overflow: Overflow.visible, children: [
              Center(
                child: Image(
                  width: 180,
                  image: AssetImage(
                    "images/pokeball.png",
                  ),
                ),
              ),
              Positioned(
                left: 200,
                top: 110,
                child: Transform.rotate(
                  angle: 5.5,
                  child: FadeTransition(
                    opacity: animation,
                    child: Center(
                      child: Image(
                        width: 80,
                        image: AssetImage(
                          "images/tapitIcon.png",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: height / 16,
            ),
            Center(
              child: Text("Check how fast you can tap !",
                  style: GoogleFonts.adventPro(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              height: height / 8,
            ),
            customButton("1 player", Colors.green, () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => OnePlayerPage(),
              ));
            }),
            SizedBox(
              height: height / 20,
            ),
            customButton("2 player", Colors.red, () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TwoPlayerPage(),
              ));
            }),
          ],
        ),
      ),
    );
  }
}
