import 'dart:async';

import 'package:flutter/material.dart';
import 'AnnotatedNumber.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer timer;
  DateTime now = DateTime.now();
  TimeOfDay comeIn;

  _MyHomePageState() : super() {
    comeIn = new TimeOfDay(hour: 8, minute: 34);
    timer = new Timer.periodic(
        new Duration(milliseconds: 10 * Duration.millisecondsPerSecond), (t) {
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

  static String _timeT(TimeOfDay comeIn) {
    return _twoDigits(comeIn.hour) + ':' + _twoDigits(comeIn.minute);
  }

  static String _timeD(Duration comeIn) {
    int minutes = comeIn.inMinutes.remainder(Duration.minutesPerHour);
    return _twoDigits(comeIn.inHours) + ':' + _twoDigits(minutes);
  }

  DateTime _toDT(TimeOfDay t) {
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  @override
  Widget build(BuildContext context) {
    var breaks = Duration(minutes: 33);
    var dur77 = Duration(hours: 7, minutes: 42);
    var plus77 = _toDT(comeIn).add(dur77);
    plus77 = plus77.add(breaks);
    var dur10 = Duration(hours: 10);
    var plus10 = _toDT(comeIn).add(dur10);
    plus10 = plus10.add(breaks);
    var working = DateTime.now().difference(_toDT(comeIn));
    var remain77 = dur77 - working;
    var remain10 = dur10 - working;

    var rows = <Widget>[
      new AnnotatedNumber(_timeD(working), "Working Time Today"),
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new AnnotatedNumber(
              _timeT(comeIn),
              "Come In",
              fontSize: 34,
              onTap: () {
                selectComeIn(context);
              },
            ),
            new AnnotatedNumber(_time(plus77), "+ 7.7h", fontSize: 34),
            new AnnotatedNumber(_time(plus10), "+ 10h", fontSize: 34),
          ]),
      new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new AnnotatedNumber(_timeD(breaks), "Breaks", fontSize: 34),
            new AnnotatedNumber(_timeD(remain77), "Remaining", fontSize: 34),
            new AnnotatedNumber(_timeD(remain10), "Remaining", fontSize: 34),
          ]),
      Text("Updated: " + DateTime.now().toString())
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Working Time Alert'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows),
    );
  }

  void selectComeIn(BuildContext context) async {
    var time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(_toDT(comeIn)));
    print(time);
    if (null != time) {
      comeIn = time;
    }
  }
}
