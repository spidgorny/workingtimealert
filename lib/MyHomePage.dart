import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AnnotatedNumber.dart';
import 'DurationRemaining.dart';
import 'TimeUtils.dart';

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

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
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

  @override
  Widget build(BuildContext context) {
    var minBreaks = (breaks.inHours > 9)
        ? Duration(minutes: 45)
        : (breaks.inHours > 6) ? Duration(minutes: 30) : Duration();
    var breaksPlus =
        Duration(minutes: max(minBreaks.inMinutes, breaks.inMinutes));
    var working = DateTime.now().difference(TimeUtils.toDT(comeIn));
    working -= breaksPlus;

    final double smallFontSize = 32;
    var rowTime = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnnotatedNumber(TimeUtils.timeD(working), "Working Time Today",
              bar: working.inMinutes / 10 / 60)
        ]);
    var rowInput = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new AnnotatedNumber(TimeUtils.timeT(comeIn), "Come In",
              fontSize: smallFontSize, onTap: () {
            selectComeIn(context);
          }, backgroundColor: Colors.blue[100]),
          new AnnotatedNumber(TimeUtils.timeD(breaks), "Breaks",
              fontSize: smallFontSize, onTap: () {
            selectBreaks(context);
          }),
        ]);

    var row77 = DurationRemaining(
        Duration(hours: 7, minutes: 42), working, comeIn, breaks);
    var row8 = DurationRemaining(Duration(hours: 8), working, comeIn, breaks);
    var dur10 = Duration(hours: 10);
    var row10 = DurationRemaining(dur10, working, comeIn, breaks);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Working Time Alert'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () async {
              const url =
                  'https://github.com/spidgorny/workingtimealert/issues';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          )
        ],
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
          row8,
          row10,
//          rowOvertimeMonth,
//          rowOvertimeTotal,
          new Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            new Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(10),
                child: Text("Updated: " + DateTime.now().toString()))
          ])
        ],
      )),
    );
  }

  void selectComeIn(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(TimeUtils.toDT(comeIn)));
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
        context: context,
        initialTime: TimeOfDay.fromDateTime(TimeUtils.DtoTD(breaks)));
    print(time);
    if (null != time) {
      setState(() {
        breaks = TimeUtils.TDtoD(time);
      });
//    await prefs.setString('breaks', time.toString());
      await storage.setItem(
          'breaks', time.hour * Duration.minutesPerHour + time.minute);
    }
  }
}
