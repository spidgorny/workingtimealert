import 'dart:ui';

import 'package:flutter/material.dart';

class AnnotatedNumber extends StatelessWidget {
  const AnnotatedNumber(this.number, this.annotation,
      {Key key, this.fontSize = 54, this.onTap, this.bar, this.backgroundColor})
      : super(key: key);

  final String number;
  final String annotation;
  final double fontSize;
  final VoidCallback onTap;
  final double bar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {

    var color;
    if (bar != null) {
      color = (bar > 0.9)
          ? Colors.red
          : (bar > 0.77)
          ? Colors.yellow
          : Theme
          .of(context)
          .accentColor;
    } else {
      color = Theme
          .of(context)
          .accentColor;
    }

    return
//      IntrinsicWidth(
//        child:
        Flexible(
            child: InkWell(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: backgroundColor ?? Colors.white,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(5.0)),
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
                    bar != null
                        ? LinearProgressIndicator(
                            value: bar,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          )
                        : new Container(),
                    new Text(annotation),
                  ]),
                ),
                onTap: onTap));
  }
}
