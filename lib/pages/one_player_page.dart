import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

const alarmAudioPath = "Pikachu.mp3";


class OnePlayerPage extends StatefulWidget {
  @override
  _OnePlayerPageState createState() => _OnePlayerPageState();
}

class _OnePlayerPageState extends State<OnePlayerPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  AnimationController controller1;
  Animation<double> animation1;

  AnimationController controller2;
  Animation<double> animation2;

  Timer _timer;
  int _start = 20;
  bool playing = false;

  int _score = 0;

  double _height = 350;
  Color colorTimer = Colors.black;

  static AudioCache player = new AudioCache();

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
            messagePopUp();
            timer.cancel();
          } else {
            _start = _start - 1;
          }

          if (_start <= 10){
            setState(() {
              colorTimer = Colors.red;
            });
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    controller1.dispose();
    controller2.dispose();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: Image.asset("images/timer.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("$_start",


                            style: GoogleFonts.adventPro(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,


                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 45,
                          child: Image.asset("images/score.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ScaleTransition(
                          scale: animation1,
                          child: Text("$_score",
                              style: GoogleFonts.adventPro(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ScaleTransition(
                  scale: animation1,
                  child: GestureDetector(
                    onTap: () {
                      player.play(alarmAudioPath);
                      setState(() {

                        if (playing) {
                          _score++;
                          controller1.forward();
                        } else
                          startTimer();
                      });
                    },
                    child: Image(
                        height: _height,
                        image: AssetImage("images/pikachu.png")),
                  ),
                ),
              ),
              Center(
                child: Row(
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
                        opacity: animation,
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
              )
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
                Text('Score : $_score'),
                Text('You did great!'),
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
      _start = 20;
      _score = 0;
      playing = false;
    });
  }
}
