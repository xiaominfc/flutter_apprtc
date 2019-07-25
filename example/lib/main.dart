import 'package:flutter/material.dart';
import 'package:flutter_apprtc/flutter_apprtc.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  connectToRoom(String room) async {
    await FlutterApprtc.startRoom(room);
  }

  genRandRoom() {
    var random = new Random();
    String room = random.nextInt(10000000).toString();
    while (room.length < 7) {
      room = "0" + room;
    }
    setState(() {
      textEditController.text = room;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('apprtc example'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                FlutterApprtc.configSetting();
              },
            )
          ],
        ),
        backgroundColor: Color.fromARGB(255, 33, 33, 33),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: textEditController,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(
                      color: Colors.white, decorationColor: Colors.white),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: const Text(
                    'Join Room',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    if (textEditController.text.length > 0) {
                      connectToRoom(textEditController.text);
                    }
                    // Perform some action
                  },
                ),
                VerticalDivider(),
                RaisedButton(
                  child: const Text(
                    'Rand Room',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    genRandRoom();
                    // Perform some action
                  },
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}
