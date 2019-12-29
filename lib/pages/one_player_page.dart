import 'package:flutter/material.dart';
import 'dart:async';
import 'menu_page.dart';

class OnePlayerPage extends StatefulWidget {
  @override
  _OnePlayerPageState createState() => _OnePlayerPageState();
}

class _OnePlayerPageState extends State<OnePlayerPage> {
  Timer _timer;
  int _start = 5;
  bool playing = false;

  int _score = 0;

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
                      Icon(Icons.timer),
                      Text("$_start"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star),
                      Text("$_score"),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (playing)
                        _score++;
                      else
                        startTimer();
                    });
                  },
                  child: FlutterLogo(
                    size: 300,
                  ),
                ),
              ),
              Opacity(
                opacity: playing ? 0.0 : 1.0,
                child: GestureDetector(
                    onTap: playing ? null : startTimer,
                    child: Text("Tap to start the timer.")),
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
      _start = 5;
      _score = 0;
      playing = false;
    });
  }
}
