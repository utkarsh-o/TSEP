import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/mentor-cached-data.dart';
import '../logic/mentor-firestore.dart';

double roundDouble(double value, int places) {
  num mod = pow(10, places);
  return ((value * mod).round().toDouble() / mod);
}

Duration getLastInteraction(List<Schedule> scheduleList) {
  Duration result = Duration(days: 1000);
  for (var s in scheduleList) {
    if (s.timing.isBefore(DateTime.now())) {
      Duration dur = s.timing.difference(DateTime.now()).abs();
      if (dur < result) result = dur;
    }
  }
  return result;
}

Duration getNextInteraction(List<Schedule> scheduleList) {
  Duration result = Duration(days: 1000);
  for (var s in scheduleList) {
    if (s.timing.isAfter(DateTime.now())) {
      Duration dur = s.timing.difference(DateTime.now()).abs();
      if (dur < result) result = dur;
    }
  }
  return result;
}

List getPlannedEngagement(List<Schedule> schedule) {
  Duration plannedEngagement = Duration();
  int plannedLessons = 0;
  for (var s in schedule) {
    if (s.postSessionSurvey) {
      plannedEngagement += Duration(minutes: s.duration);
      plannedLessons++;
    }
  }
  return [plannedEngagement, plannedLessons];
}

List<double> getLectureHourRate(
    DateTime joiningDate, List<Schedule> scheduleList) {
  int lecturesTaken = 0;
  Duration hoursTaken = Duration(seconds: 0);
  int weekLeft =
      10 - ((DateTime.now().difference(joiningDate).inDays) / 7).floor();
  for (var s in scheduleList) {
    if (s.timing.isBefore(DateTime.now())) {
      lecturesTaken++;
      hoursTaken += Duration(minutes: s.duration);
    }
  }
  double lecturesPerWeek = roundDouble((30 - lecturesTaken) / weekLeft, 1);
  double hoursPerWeek = roundDouble((15 - hoursTaken.inHours) / weekLeft, 1);
  return [lecturesPerWeek, hoursPerWeek];
}

String formatLastInteraction(Duration result) {
  if (result == Duration(days: 1000) || result > Duration(days: 80)) {
    return "-";
  } else {
    if (result.inHours > 24) {
      return "${(result.inHours / 24).floor()} days, ${result.inHours % 24} hours ago";
    } else
      return "${result.inHours} hours ago";
  }
}

int parseIntFromString(String s) =>
    int.parse(s.replaceAll(new RegExp(r'[^0-9]'), ''));

String formatNextInteraction(Duration result) {
  if (result == Duration(days: 1000)) {
    return "-";
  } else {
    if (result.inHours > 24) {
      return "in ${(result.inHours / 24).floor()} days ${result.inHours % 24} hours";
    } else
      return "in ${result.inHours} hours";
  }
}

String parseInitials(name) {
  List<String> names = name.split(" ");
  String initials = "";
  int numWords = 2;

  if (numWords < names.length) {
    numWords = names.length;
  }
  for (var i = 0; i < numWords; i++) {
    initials += '${names[i][0]}';
  }
  return initials;
}

List getTotalContribution(List<Schedule> schedule) {
  Duration totalConrtibution = Duration();
  DateTime today = DateTime.now();
  int totalLessons = 0;
  for (var s in schedule)
    if (s.timing.add(Duration(minutes: s.duration)).isBefore(today) &&
        s.postSessionSurvey) {
      totalConrtibution += Duration(minutes: s.duration);
      totalLessons++;
    }
  return [totalConrtibution, totalLessons];
}

bool iseventful(List<Schedule> schedule, DateTime today) {
  for (var s in schedule)
    if (s.timing.day == today.day &&
        s.timing.month == today.month &&
        s.timing.year == today.year) return true;
  return false;
}

bool isActive(DateTime date) {
  DateTime today = DateTime.now();
  if (today.year == date.year &&
      today.day == date.day &&
      today.month == date.month) return true;
  return false;
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm(); //"6:00 AM"
  return format.format(dt);
}

List<FlSpot> getMentorLessonChartData(DateTime joiningDate) {
  List<FlSpot> result = [];
  Map<int, int> map = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
    10: 0,
  };
  for (var s in mentorSchedule) {
    int week = (s.timing.difference(joiningDate).inDays / 7).floor() + 1;
    if (map.containsKey(week)) {
      map.update(week, (val) => val + 1);
    } else
      map[week] = 1;
  }
  for (int i = 1; i <= 10; i++) {
    if (map.containsKey(i))
      result.add(FlSpot(i.toDouble(), map[i]!.toDouble()));
  }
  return result;
}

List<FlSpot> getMentorHourChartData(DateTime joiningDate) {
  //TODO:initialize middle weeks without values to 0;
  List<FlSpot> result = [];
  Map<int, double> map = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0,
    10: 0,
  };
  for (var s in mentorSchedule) {
    int week = (s.timing.difference(joiningDate).inDays / 7).floor() + 1;
    if (map.containsKey(week)) {
      map.update(week, (val) => val + s.duration / 60);
    } else
      map[week] = s.duration / 60;
  }
  for (int i = 1; i <= 10; i++) {
    if (map.containsKey(i))
      result.add(FlSpot(i.toDouble(), map[i]!.toDouble()));
  }
  return result;
}
