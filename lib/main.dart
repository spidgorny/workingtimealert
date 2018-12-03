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
  @override

  var now = DateTime.now();
  var comeIn = new DateTime(now.year, now.month, now.day, 8, 33);
  var breaks = Duration(minutes: 33);

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Working Time Alert'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new AnnotatedNumber("05:58", "Working Time"),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new AnnotatedNumber("08:55", "Come In", fontSize: 34),
                  new AnnotatedNumber("17:05", "+ 7.7h", fontSize: 34),
                  new AnnotatedNumber("18:55", "+ 10h", fontSize: 34),
                ]),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new AnnotatedNumber("00:33", "Breaks", fontSize: 34),
                  new AnnotatedNumber("02:05", "Remaining", fontSize: 34),
                  new AnnotatedNumber("03:15", "Remaining", fontSize: 34),
                ])
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
