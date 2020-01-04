import 'package:flutter/material.dart';
import 'package:tap_it/pages/one_player_page.dart';
import 'package:tap_it/pages/two_player_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {




  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  int myInt;
  SharedPreferences prefs;

  initState()  {
    super.initState();
    getPrefs();
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

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    myInt = prefs.getInt('highscore') ?? 0;

    setState(() {
    });
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
    getPrefs();
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
              height: height / 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  child: Image.asset(
                      "images/award.png",),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(myInt.toString() == null ? "0" : myInt.toString() ,style: GoogleFonts.adventPro(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            SizedBox(
              height: height / 20,
            ),
            customButton("1 player", Colors.green, () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => OnePlayerPage(),
              ));
            }),
            SizedBox(
              height: height / 20,
            ),
            customButton("2 player", Colors.red, () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => TwoPlayerPage(),
              ));
            }),
          ],
        ),
      ),
    );
  }
}
