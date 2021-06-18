import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tsep/local-data/schedule.dart';
import 'package:tsep/screens/schedule-page.dart';

final firestore = FirebaseFirestore.instance;

class ScheduleComplete extends StatelessWidget {
  String uid;
  ScheduleComplete({required this.uid});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              TitleBar(),
              StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('MentorData/${uid}/Schedule')
                    .orderBy('LectureTime')
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
                  DateTime endDate = _firstDayOfTheweek.add(Duration(days: 7));
                  List<Widget> ScheduleCardList = [];
                  if (snapshot.hasData) {
                    scheduleList.clear();
                    final schedules = snapshot.data!.docs;
                    var x = 1;
                    for (var schedule in schedules) {
                      var lectureTime = schedule.get('LectureTime').toDate();
                      Schedule s = Schedule(
                        mentee: schedule.get('MenteeName'),
                        lesson: schedule.get('LectureNumber'),
                        duration: schedule.get('Duration'),
                        timing: schedule.get('LectureTime').toDate(),
                        mentorSchID: schedule.id,
                        menteeSchID: schedule.get('MenteeScheduleID'),
                        menteeUID: schedule.get('MenteeUID'),
                      );
                      scheduleList.add(s);
                      // if (lectureTime.isAfter(startDate) &&
                      //     lectureTime.isBefore(endDate)) {
                      ScheduleCardList.add(
                        new ScheduleCard(
                          s: s,
                          index: x++,
                        ),
                      );
                      // }
                    }
                  }
                  return Column(
                    children: [
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
    );
  }
}

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/back-tb.svg",
              height: screenWidth * 0.07,
            ),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.05,
          height: screenHeight * 0.12,
        ),
        Container(
          child: Text(
            "Compete Schedule",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final Schedule s;
  int index;
  ScheduleCard({required this.s, required this.index});
  @override
  Widget build(BuildContext context) {
    var weekday = DateFormat('EEE d MMMM').format(s.timing);
    var lesson = s.lesson;
    String starttime = DateFormat('hh:mm').format(s.timing);
    starttime = starttime.replaceAll("AM", "am").replaceAll("PM", "pm");
    String endtime = DateFormat('hh:mm a')
        .format(s.timing.add(Duration(minutes: s.duration)));
    endtime = endtime.replaceAll("AM", "am").replaceAll("PM", "pm");
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  height: size.height * 0.2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delete Lecture",
                          style: TextStyle(
                              color: Color(0xffD92136).withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            color: Color(0xff1F78B4).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Are you sure? this action cannot be undone.",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: Color(0xff1F78B4).withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        CanDelBtnWrapper(
                          s: s,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Padding(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 35,
                width: 40,
                margin: EdgeInsets.only(right: 5, left: 15),
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
                    index.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: size.width * 0.32),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5),
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
    Duration ttlcnt = getschcnt(s);
    String ttlcnthr = ttlcnt.inHours.toString();
    String ttlcntmn = ttlcnt.inMinutes.remainder(60).toString();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TotContriLesTau(
              heading: "Planned Engagement",
              value: "${ttlcnthr}hr ${ttlcntmn}min"),
          TotContriLesTau(
              heading: "Planned Lessons", value: schlsns.toString()),
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
