import 'dart:math';

import 'package:flutter/material.dart';

import 'AnnotatedNumber.dart';
import 'TimeUtils.dart';

class DurationRemaining extends StatelessWidget {
  final TimeOfDay comeIn;
  final Duration breaks;
  final Duration dur10;
  final Duration working;
  DateTime plus10;
  Duration remain10;
  final double smallFontSize = 32;

  DurationRemaining(this.dur10, this.working, this.comeIn, this.breaks) {
    plus10 = TimeUtils.toDT(comeIn).add(dur10).add(breaks);

    var minBreaks = (breaks.inHours > 9)
        ? Duration(minutes: 45)
        : (breaks.inHours > 6) ? Duration(minutes: 30) : Duration();
    var breaksPlus =
        Duration(minutes: max(minBreaks.inMinutes, breaks.inMinutes));

    var working = DateTime.now().difference(TimeUtils.toDT(comeIn));
    working -= breaksPlus;
    remain10 = dur10 - working;
  }

  @override
  Widget build(BuildContext context) {
    var durInH = (dur10.inMinutes / 60).toStringAsFixed(1);
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new AnnotatedNumber(TimeUtils.time(plus10), "+ ${durInH}h",
              fontSize: smallFontSize),
          new AnnotatedNumber(TimeUtils.timeD(remain10), "Remaining",
              fontSize: smallFontSize,
              backgroundColor:
                  remain10.inMinutes < 60 ? Colors.red : Colors.white),
        ]);
  }
}
