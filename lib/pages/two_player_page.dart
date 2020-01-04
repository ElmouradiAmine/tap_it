import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';


class TwoPlayerPage extends StatefulWidget {
  @override
  _TwoPlayerPageState createState() => _TwoPlayerPageState();
}

class _TwoPlayerPageState extends State<TwoPlayerPage> with TickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;

  AnimationController controller1;
  Animation<double> animation1;

  AnimationController controller3;
  Animation<double> animation3;

  Timer _timer;
  int _start = 30;
  bool playing = false;

  int _score1 = 0;
  int _score2 = 0;

  initState() {
    super.initState();
    controller = AnimationController(
        lowerBound: 0.7,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 400),
        vsync: this);
    animation =
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });


    controller1 = AnimationController(
        lowerBound: 0.7,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 400),
        vsync: this);
    animation1 =
        CurvedAnimation(parent: controller1, curve: Curves.bounceInOut);

    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      }
    });

    controller3 = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    animation3 = CurvedAnimation(parent: controller3, curve: Curves.easeIn);

    animation3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller3.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller3.forward();
      }
    });
//this will start the animation
    controller3.forward();



//this will start the animation
  }
  void startTimer() {
    playing = true;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            messagePopUp();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.lightGreen[100],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 30,
                        child: Image.asset("images/timer.png"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("$_start",style: GoogleFonts.adventPro(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          width: 45,
                          child: Image.asset("images/score1.png")),
                      SizedBox(
                        width: 10,
                      ),
                      Text("$_score1",style: GoogleFonts.adventPro(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          width: 45,
                          child: Image.asset("images/score.png",)),
                      SizedBox(
                        width: 10,
                      ),
                      Text("$_score2",style: GoogleFonts.adventPro(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ScaleTransition(
                  scale: animation1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (playing){
                          _score1++;
                          controller1.forward();
                        }
                        else
                          startTimer();

                        if (_score1 - _score2 >= 20){
                          _timer.cancel();
                          messagePopUp();
                        }
                      });
                    },
                    child: Container(
                    width: 240,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "images/player1.png"
                          ),
                        )
                    ),
                  ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 20 - _score2 + _score1,
                    child: Container(
                      height: 20,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    flex : 20 + _score2 - _score1,
                    child: Container(
                      height: 20,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ScaleTransition(
                  scale: animation,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (playing){
                          _score2++;
                          controller.forward();
                        }


                        else
                          startTimer();

                        if (_score2 - _score1 >= 20){
                          _timer.cancel();
                          messagePopUp();
                        }
                      });
                    },
                    child: Container(
                      width: 240,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "images/pikachu.png"
                          ),
                        )
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: 40.0,
                      height: 40.0,
                      child: new RawMaterialButton(
                        fillColor: Colors.red,
                        shape: new CircleBorder(),
                        elevation: 5.0,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          Navigator.of(context).popUntil(ModalRoute.withName("/"));
                        },
                      )),
                  Opacity(
                    opacity: playing ? 0 : 1,
                    child: FadeTransition(
                      opacity: animation3,
                      child: GestureDetector(
                        onTap: playing ? null : startTimer,
                        child: Text("Tap to start the timer.",
                            style: GoogleFonts.adventPro(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                  Container(
                      width: 40.0,
                      height: 40.0,
                      child: new RawMaterialButton(
                        fillColor: Colors.green,
                        shape: new CircleBorder(),
                        elevation: 5.0,
                        child: Icon(
                          Icons.replay,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          _timer.cancel();
                          _replay();
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> messagePopUp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        print("The message has popped");
        bool canClick = false;
        Future.delayed(Duration(
          seconds: 2,
        )).then((data) {
          canClick = true;
          print("you can click now!");
        });

        return AlertDialog(
          title: Text('Time out !'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Player 1 : $_score1'),
                Text('Player 2 : $_score2'),
                Text(_score2 > _score1 ? "Player 2 wins." : (_score2 == _score1 ?  "It's a draw." : "Player 1 wins.")),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Replay'),
              color: Colors.green,
              onPressed: () {
                if (canClick) {
                  _replay();
                  Navigator.of(context).pop();
                }
              },
            ),
            FlatButton(
              child: Text('Menu'),
              color: Colors.red,
              onPressed: () {
                if (canClick) {
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _replay() {
    setState(() {
      _start = 30;
      _score1 = 0;
      _score2 = 0;
      playing = false;
    });
  }
}
