import 'package:flutter/material.dart';

class TimeUtils {
  static String _twoDigits(int n) {
    n = n.abs();
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  static String time(DateTime comeIn) {
    return _twoDigits(comeIn.hour) + ':' + _twoDigits(comeIn.minute);
  }

  static String timeT(TimeOfDay comeIn) {
    return _twoDigits(comeIn.hour) + ':' + _twoDigits(comeIn.minute);
  }

  static String _sign(Duration comeIn) {
    if (comeIn.isNegative) {
      return '-';
    }
    return '';
  }

  static String timeD(Duration comeIn) {
    int minutes = comeIn.inMinutes.remainder(Duration.minutesPerHour);
    return _sign(comeIn) +
        _twoDigits(comeIn.inHours) +
        ':' +
        _twoDigits(minutes);
  }

  static DateTime toDT(TimeOfDay t) {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  static DateTime DtoTD(Duration d) {
    DateTime now = DateTime.now();
    int minutes = d.inMinutes.remainder(Duration.minutesPerHour);
    return DateTime(now.year, now.month, now.day, d.inHours, minutes);
  }

  static Duration TDtoD(TimeOfDay d) {
    return Duration(hours: d.hour, minutes: d.minute);
  }
}
