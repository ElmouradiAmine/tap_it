import 'package:flutter/material.dart';
import 'dart:async';

class TwoPlayerPage extends StatefulWidget {
  @override
  _TwoPlayerPageState createState() => _TwoPlayerPageState();
}

class _TwoPlayerPageState extends State<TwoPlayerPage> {
  Timer _timer;
  int _start = 30;
  bool playing = false;

  int _score1 = 0;
  int _score2 = 0;


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
                      Icon(Icons.star,color: Colors.red,),
                      Text("$_score1"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star,color: Colors.green,),
                      Text("$_score2"),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (playing)
                        _score1++;

                      else
                        startTimer();

                      if (_score1 - _score2 >= 20){
                        _timer.cancel();
                        messagePopUp();
                      }
                    });
                  },
                  child: FlutterLogo(
                    size: 150,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 20 - _score2 + _score1,
                    child: Container(
                      height: 20,
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    flex : 20 + _score2 - _score1,
                    child: Container(
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (playing)
                        _score2++;

                      else
                        startTimer();

                      if (_score2 - _score1 >= 20){
                        _timer.cancel();
                        messagePopUp();
                      }
                    });
                  },
                  child: FlutterLogo(
                    size: 150,
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
