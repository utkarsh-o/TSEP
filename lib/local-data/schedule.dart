import 'dart:ffi';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:tsep/screens/mentor-profile.dart';

class Schedule {
  String mentee, lesson;
  DateTime timing;
  int duration;

  Schedule({
    required this.mentee,
    required this.lesson,
    required this.duration,
    required this.timing,
  });
}

List<Schedule> scheduleList = [
  // Schedule(
  //   mentee: 'Iron Man',
  //   lesson: 'lesson 6',
  //   duration: 60,
  //   timing: DateTime.parse('2021-06-19 16:00:00'),
  // ),
  // Schedule(
  //   mentee: 'Spider Man',
  //   lesson: 'lesson 5',
  //   duration: 30,
  //   timing: DateTime.parse('2021-06-17 15:00:00'),
  // ),
  // Schedule(
  //   mentee: 'Bat Man',
  //   lesson: 'lesson 3',
  //   duration: 50,
  //   timing: DateTime.parse('2021-06-16 18:30:00'),
  // ),
  // Schedule(
  //   mentee: 'Ant Man',
  //   lesson: 'lesson 2',
  //   duration: 50,
  //   timing: DateTime.parse('2021-06-14 17:30:00'),
  // ),
];
int ttllsns = 0;
Duration getttlctr(List<Schedule> schedule) {
  Duration ttlctr = Duration();
  DateTime today = DateTime.now();
  ttllsns = 0;
  for (var s in schedule)
    if (s.timing.add(Duration(minutes: s.duration)).isBefore(today)) {
      ttlctr += Duration(minutes: s.duration);
      ttllsns++;
    }
  return ttlctr;
}

String getLastInteraction() {
  Duration result = Duration(days: 1000);
  for (var s in scheduleList) {
    if (s.timing.isBefore(DateTime.now())) {
      Duration dur = s.timing.difference(DateTime.now()).abs();
      if (dur < result) result = dur;
    }
  }
  if (result == Duration(days: 1000) || result > Duration(days: 70)) {
    return "-";
  } else {
    if (result.inHours > 24) {
      return "${(result.inHours / 24).floor()} days, ${result.inHours % 24} hours";
    } else
      return "${result.inHours} hours";
  }
}

String getNextInteraction() {
  Duration result = Duration(days: 1000);
  for (var s in scheduleList) {
    if (s.timing.isAfter(DateTime.now())) {
      Duration dur = s.timing.difference(DateTime.now()).abs();
      if (dur < result) result = dur;
    }
  }
  if (result == Duration(days: 1000)) {
    return "-";
  } else {
    if (result.inHours > 24) {
      return "${(result.inHours / 24).floor()} days : ${result.inHours % 24} hours";
    } else
      return "${result.inHours} hours";
  }
}

double roundDouble(double value, int places) {
  num mod = pow(10, places);
  return ((value * mod).round().toDouble() / mod);
}

List<double> getLecHrRate(DateTime joiningDate) {
  int lectaken = 0;
  Duration hrtaken = Duration(seconds: 0);
  int weekleft =
      10 - ((DateTime.now().difference(joiningDate).inDays) / 7).floor();
  for (var s in scheduleList) {
    if (s.timing.isBefore(DateTime.now())) {
      lectaken++;
      hrtaken += Duration(minutes: s.duration);
    }
  }
  double lecrate = roundDouble((30 - lectaken) / weekleft, 1);
  double hrrate = roundDouble((15 - hrtaken.inHours) / weekleft, 1);
  return [lecrate, hrrate];
}

List<FlSpot> getlessonChartData(DateTime JoiningDate) {
  //TODO:initialize middle weeks without values to 0;
  List<FlSpot> result = [];
  Map<int, int> map = {};
  for (var s in scheduleList) {
    if (s.timing.isBefore(DateTime.now())) {
      int week = (s.timing.difference(JoiningDate).inDays / 7).floor() + 1;
      if (map.containsKey(week)) {
        map.update(week, (val) => val + 1);
      } else
        map[week] = 1;
    }
  }
  for (int i = 1; i <= 10; i++) {
    if (map.containsKey(i))
      result.add(FlSpot(i.toDouble(), map[i]!.toDouble()));
  }
  print(result);
  return result;
}

List<FlSpot> gethourChartData(DateTime JoiningDate) {
  //TODO:initialize middle weeks without values to 0;
  List<FlSpot> result = [];
  Map<int, double> map = {};
  for (var s in scheduleList) {
    if (s.timing.isBefore(DateTime.now())) {
      int week = (s.timing.difference(JoiningDate).inDays / 7).floor() + 1;
      if (map.containsKey(week)) {
        map.update(week, (val) => val + s.duration / 60);
      } else
        map[week] = s.duration / 60;
    }
  }
  for (int i = 1; i <= 10; i++) {
    if (map.containsKey(i))
      result.add(FlSpot(i.toDouble(), map[i]!.toDouble()));
  }
  print(result);
  return result;
}

bool iseventful(List<Schedule> schedule, DateTime today) {
  for (var s in schedule)
    if (s.timing.day == today.day &&
        s.timing.month == today.month &&
        s.timing.year == today.year) return true;
  return false;
}

bool isactive(DateTime date) {
  DateTime today = DateTime.now();
  if (today.year == date.year &&
      today.day == date.day &&
      today.month == date.month) return true;
  return false;
}
