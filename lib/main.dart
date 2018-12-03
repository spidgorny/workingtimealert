import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Working Time Alert',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer timer;
  DateTime now = DateTime.now();

  _MyHomePageState() : super() {
    timer = new Timer.periodic(new Duration(milliseconds: 10 * Duration.millisecondsPerSecond), (t) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  static String _time(DateTime comeIn) {
    return _twoDigits(comeIn.hour) + ':' + _twoDigits(comeIn.minute);
  }

  static String _timeD(Duration comeIn) {
    int minutes = comeIn.inMinutes.remainder(Duration.minutesPerHour);
    return _twoDigits(comeIn.inHours) + ':' + _twoDigits(minutes);
  }

  @override
  Widget build(BuildContext context) {
    var comeIn = new DateTime(now.year, now.month, now.day, 8, 34);
    var breaks = Duration(minutes: 33);
    var dur77 = Duration(hours: 7, minutes: 42);
    var plus77 = comeIn.add(dur77);
    plus77 = plus77.add(breaks);
    var dur10 = Duration(hours: 10);
    var plus10 = comeIn.add(dur10);
    plus10 = plus10.add(breaks);
    var working = DateTime.now().difference(comeIn);
    var remain77 = dur77 - working;
    var remain10 = dur10 - working;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Working Time Alert'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new AnnotatedNumber(_timeD(working), "Working Time Today"),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new AnnotatedNumber(_time(comeIn), "Come In", fontSize: 34),
                  new AnnotatedNumber(_time(plus77), "+ 7.7h", fontSize: 34),
                  new AnnotatedNumber(_time(plus10), "+ 10h", fontSize: 34),
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new AnnotatedNumber(_timeD(breaks), "Breaks", fontSize: 34),
                  new AnnotatedNumber(_timeD(remain77), "Remaining",
                      fontSize: 34),
                  new AnnotatedNumber(_timeD(remain10), "Remaining",
                      fontSize: 34),
                ]),
            Text("Updated: " + DateTime.now().toString())
          ]),
    );
  }
}

class AnnotatedNumber extends StatelessWidget {
  const AnnotatedNumber(this.number, this.annotation,
      {Key key, this.fontSize = 54})
      : super(key: key);

  final String number;
  final String annotation;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
        boxShadow: [
          new BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.5),
            offset: new Offset(5.0, 5.0),
            blurRadius: 10.0,
          )
        ],
      ),
      child: new Column(children: [
        new Text(
          number,
          style: new TextStyle(
              fontSize: fontSize,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w200,
              fontFamily: "Roboto"),
        ),
        new Text(annotation),
      ]),
    );
  }
}
