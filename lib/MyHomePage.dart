import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

//import 'package:shared_preferences/shared_preferences.dart';
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
  Duration breaks;

//  SharedPreferences prefs;
  final LocalStorage storage = new LocalStorage('MyHomePage');

  _MyHomePageState() : super();

  @override
  void initState() {
    super.initState();
//    prefs = await SharedPreferences.getInstance();

    comeIn = new TimeOfDay(hour: 8, minute: 30);
    initComeIn();

    breaks = Duration(minutes: 30);
    initBreaks();

    timer = new Timer.periodic(
        new Duration(milliseconds: 10 * Duration.millisecondsPerSecond), (t) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  void initComeIn() async {
    print('await storage.ready');
    await storage.ready;
    int iComeIn = storage.getItem('comeIn');
    print('iComeIn ' + iComeIn.toString());
    if (iComeIn != null) {
      setState(() {
        comeIn = TimeOfDay(
            hour: (iComeIn / Duration.minutesPerHour).round(),
            minute: iComeIn % Duration.minutesPerHour);
      });
    }
  }

  void initBreaks() async {
    //    int breaksMinutes = prefs.getString('breaks') ?? 0;
    print('await storage.ready');
    await storage.ready;
    int iBreaks = storage.getItem('breaks');
    print('iBreaks ' + iBreaks.toString());
    if (iBreaks != null) {
      setState(() {
        breaks = Duration(minutes: iBreaks);
      });
    }
  }

  static String _twoDigits(int n) {
    n = n.abs();
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  static String _time(DateTime comeIn) {
    return _twoDigits(comeIn.hour) + ':' + _twoDigits(comeIn.minute);
  }

  static String _timeT(TimeOfDay comeIn) {
    return _twoDigits(comeIn.hour) + ':' + _twoDigits(comeIn.minute);
  }

  static String _sign(Duration comeIn) {
    if (comeIn.isNegative) {
      return '-';
    }
    return '';
  }

  static String _timeD(Duration comeIn) {
    int minutes = comeIn.inMinutes.remainder(Duration.minutesPerHour);
    return _sign(comeIn) +
        _twoDigits(comeIn.inHours) +
        ':' +
        _twoDigits(minutes);
  }

  DateTime _toDT(TimeOfDay t) {
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  DateTime _DtoTD(Duration d) {
    int minutes = d.inMinutes.remainder(Duration.minutesPerHour);
    return DateTime(now.year, now.month, now.day, d.inHours, minutes);
  }

  Duration _TDtoD(TimeOfDay d) {
    return Duration(hours: d.hour, minutes: d.minute);
  }

  @override
  Widget build(BuildContext context) {
    var minBreaks = (breaks.inHours > 9)
        ? Duration(minutes: 45)
        : (breaks.inHours > 6) ? Duration(minutes: 30) : Duration();
    var breaksPlus =
        Duration(minutes: max(minBreaks.inMinutes, breaks.inMinutes));
    var dur77 = Duration(hours: 7, minutes: 42);
    var plus77 = _toDT(comeIn).add(dur77).add(breaks);
    var dur10 = Duration(hours: 10);
    var plus10 = _toDT(comeIn).add(dur10).add(breaks);
    var working = DateTime.now().difference(_toDT(comeIn));
    working -= breaksPlus;
    var remain77 = dur77 - working;
    var remain10 = dur10 - working;

    final double smallFontSize = 32;
    var rowTime = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnnotatedNumber(_timeD(working), "Working Time Today",
              bar: working.inMinutes / 10 / 60)
        ]);
    var rowInput = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new AnnotatedNumber(
            _timeT(comeIn),
            "Come In",
            fontSize: smallFontSize,
            onTap: () {
              selectComeIn(context);
            },
          ),
          new AnnotatedNumber(_timeD(breaks), "Breaks", fontSize: smallFontSize,
              onTap: () {
            selectBreaks(context);
          }),
        ]);

    var row77 = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new AnnotatedNumber(_time(plus77), "+ 7.7h", fontSize: smallFontSize),
          new AnnotatedNumber(
            _timeD(remain77),
            "Remaining",
            fontSize: smallFontSize,
            backgroundColor:
                remain77.inMinutes < 60 ? Colors.yellow : Colors.white,
          ),
        ]);

    var row10 = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new AnnotatedNumber(_time(plus10), "+ 10h", fontSize: smallFontSize),
          new AnnotatedNumber(_timeD(remain10), "Remaining",
              fontSize: smallFontSize,
              backgroundColor:
                  remain10.inMinutes < 60 ? Colors.red : Colors.white),
        ]);

    var rowOvertimeMonth = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[AnnotatedNumber("??:??", "Overtime Current Month")]);

    var rowOvertimeTotal = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[AnnotatedNumber("??:??", "Total Overtime")]);

    print('render');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Working Time Alert'),
      ),
      body: SingleChildScrollView(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          rowTime,
          rowInput,
          row77,
          row10,
          rowOvertimeMonth,
          rowOvertimeTotal,
          new Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            new Container(
                alignment: Alignment.bottomRight,
                child: Text("Updated: " + DateTime.now().toString()))
          ])
        ],
      )),
    );
  }

  void selectComeIn(BuildContext context) async {
    var time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(_toDT(comeIn)));
    //print(time);
    if (null != time) {
      setState(() {
        comeIn = time;
      });
      await storage.setItem(
          'comeIn', time.hour * Duration.minutesPerHour + time.minute);
    }
  }

  void selectBreaks(BuildContext context) async {
    var time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(_DtoTD(breaks)));
    print(time);
    if (null != time) {
      setState(() {
        breaks = _TDtoD(time);
      });
//    await prefs.setString('breaks', time.toString());
      await storage.setItem(
          'breaks', time.hour * Duration.minutesPerHour + time.minute);
    }
  }
}
