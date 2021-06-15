import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tsep/components/CustomNavigationBar.dart';
import 'package:tsep/components/loading.dart';
import 'package:tsep/local-data/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
String? uid;
bool loading = false;

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  void getCurrentUser() async {
    try {
      final user = await auth.currentUser;
      if (user != null) {
        uid = user.uid;
        // print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }

  // Just Kept here for reference, using StreamBuilder instead not
  // Future<Widget> getScheduleStream() async {
  //   DateTime today = DateTime.now();
  //   DateTime _firstDayOfTheweek =
  //       today.subtract(new Duration(days: today.weekday));
  //   DateTime startDate = _firstDayOfTheweek.add(Duration(days: 1));
  //   DateTime endDate = _firstDayOfTheweek.add(Duration(days: 7));
  //   List<Widget> ScheduleList = [];
  //   await for (var snapshot
  //       in firestore.collection('MentorData/${uid}/Schedule').snapshots()) {
  //     for (var schedule in snapshot.docs) {
  //       var lectureTime = schedule.get('LectureTime').toDate();
  //       if (lectureTime.isAfter(startDate) && lectureTime.isBefore(endDate)) {
  //         Schedule s = Schedule(
  //           mentee: schedule.get('MenteeName'),
  //           lesson: schedule.get('LessonNumber'),
  //           duration: schedule.get('Duration'),
  //           timing: schedule.get('LectureTime'),
  //         );
  //         ScheduleList.add(new ScheduleCard(
  //           s: s,
  //         ));
  //       }
  //     }
  //   }
  //   return new ListView(children: ScheduleList);
  // }

  @override
  Widget build(BuildContext context) {
    @override
    Size size = MediaQuery.of(context).size;
    // Deprecitated, using streamBuilder now !
    // Widget getSchedule() {
    //   DateTime today = DateTime.now();
    //   DateTime _firstDayOfTheweek =
    //       today.subtract(new Duration(days: today.weekday));
    //   DateTime startDate = _firstDayOfTheweek.add(Duration(days: 1));
    //   DateTime endDate = _firstDayOfTheweek.add(Duration(days: 7));
    //
    //   List<Widget> ScheduleList = [];
    //   for (var sche in schedule) {
    //     if (sche.timing.isAfter(startDate) && sche.timing.isBefore(endDate))
    //       ScheduleList.add(new ScheduleCard(s: sche));
    //   }
    //   return new ListView(children: ScheduleList);
    // }

    Widget getDayCards() {
      DateTime today = DateTime.now();
      DateTime _firstDayOfTheweek =
          today.subtract(new Duration(days: today.weekday));
      List<Widget> DayList = [];
      DayList.add(SizedBox(width: size.width * 0.02));
      for (var index = 1; index <= 7; index++) {
        DayList.add(
          new DayCard(
            date: _firstDayOfTheweek.add(
              Duration(days: index),
            ),
          ),
        );
      }
      DayList.add(SizedBox(width: size.width * 0.02));
      return new Row(
        children: DayList,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TitleBar(),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection('MentorData/${uid}/Schedule')
                          .snapshots(),
                      builder: (context, snapshot) {
                        DateTime today = DateTime.now();
                        DateTime _firstDayOfTheweek =
                            today.subtract(new Duration(days: today.weekday));
                        DateTime startDate = _firstDayOfTheweek
                            .add(Duration(days: 1))
                            .subtract(Duration(
                                hours: TimeOfDay.now().hour,
                                minutes: TimeOfDay.now().minute));
                        DateTime endDate =
                            _firstDayOfTheweek.add(Duration(days: 7));
              ◘          List<Widget> ScheduleCardList = [];
                        if (snapshot.hasData) {
                          scheduleList.clear();
                          final schedules = snapshot.data!.docs;
                          for (var schedule in schedules) {
                            var lectureTime =
                                schedule.get('LectureTime').toDate();
                            Schedule s = Schedule(
                              mentee: schedule.get('MenteeName'),
                              lesson: schedule.get('LectureNumber'),
                              duration: schedule.get('Duration'),
                              timing: schedule.get('LectureTime').toDate(),
                            );
                            scheduleList.add(s);
                            if (lectureTime.isAfter(startDate) &&
                                lectureTime.isBefore(endDate)) {
                              ScheduleCardList.add(
                                new ScheduleCard(s: s),
                              );
                            }
                          }
                        }
                        return Column(
                          children: [
                            getDayCards(),
                            BreakLine(size: size),
                            TotContriLesTauWrapper(s: scheduleList),
                            BreakLine(size: size),
                            Column(
                              children: ScheduleCardList,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavBar(
              active: 1,
            ),
          );
  }
}

class TotContriLesTauWrapper extends StatelessWidget {
  final List<Schedule> s;
  TotContriLesTauWrapper({
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    Duration ttlcnt = getttlctr(s);
    String ttlcnthr = ttlcnt.inHours.toString();
    String ttlcntmn = ttlcnt.inMinutes.remainder(60).toString();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TotContriLesTau(
              heading: "Total Contribution",
              value: "${ttlcnthr}hr ${ttlcntmn}min"),
          TotContriLesTau(heading: "Lessons Taught", value: ttllsns.toString()),
        ],
      ),
    );
  }
}

class TotContriLesTau extends StatelessWidget {
  final String heading, value;
  TotContriLesTau({required this.heading, required this.value});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xffD92136).withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final Schedule s;
  ScheduleCard({required this.s});
  @override
  Widget build(BuildContext context) {
    var weekday = DateFormat('EEE').format(s.timing);
    var lesson = s.lesson;
    String starttime = DateFormat('hh:mm').format(s.timing);
    starttime = starttime.replaceAll("AM", "am").replaceAll("PM", "pm");
    String endtime = DateFormat('hh:mm a')
        .format(s.timing.add(Duration(minutes: s.duration)));
    endtime = endtime.replaceAll("AM", "am").replaceAll("PM", "pm");
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        width: size.width * 0.9,
        height: size.height * 0.1,
        child: Row(
          children: [
            Container(
              height: 35,
              width: 40,
              margin: EdgeInsets.symmetric(horizontal: 17),
              decoration: BoxDecoration(
                color: Color(0xff003670).withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff003670).withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  DateFormat('d').format(s.timing),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: size.width * 0.25),
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.mentee,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "$weekday, $lesson",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Text(
                    "$starttime - $endtime",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: Color(0xff268200).withOpacity(0.7),
                      size: 12,
                    ),
                    Text(
                      "  ${s.duration} mins",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xff269200).withOpacity(0.7),
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BreakLine extends StatelessWidget {
  const BreakLine({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 18),
      height: 1,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Color(0xff003670).withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final DateTime date;
  DayCard({
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    bool active = isactive(date);
    bool event = iseventful(scheduleList, date);
    Color fontColor = active ? Colors.white : Colors.black.withOpacity(0.7);
    Color eventColor = active
        ? Colors.white.withOpacity(0.7)
        : Color(0xff003670).withOpacity(0.8);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 40,
      decoration: active
          ? BoxDecoration(
              color: Color(0xff003670).withOpacity(0.8),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff003670).withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            )
          : null,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 4, right: 4),
            child: Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: fontColor,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: fontColor,
              ),
            ),
          ),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: event,
            child: Container(
              margin: EdgeInsets.only(top: 3, bottom: 10),
              height: size.height * 0.005,
              width: size.width * 0.03,
              color: eventColor,
            ),
          )
        ],
      ),
    );
  }
}

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Text(
            "Schedule",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.4,
          height: screenHeight * 0.12,
        ),
        SvgPicture.asset(
          "assets/icons/settings-tb.svg",
          height: screenWidth * 0.06,
        )
      ],
    );
  }
}
