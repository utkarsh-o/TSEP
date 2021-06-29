import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../local-data/constants.dart';
import '../logic/cached-data.dart';
import '../logic/data-processing.dart';
import '../logic/firestore.dart';
import '../screens/post-session-survey.dart';
import 'edit_lecture.dart';

final firestore = FirebaseFirestore.instance;
List<Schedule> scheduleList = [];
Map<String, dynamic> oldData = {}, newData = {};

class ScheduleComplete extends StatefulWidget {
  static String route = "ScheduleComplete";

  @override
  _ScheduleCompleteState createState() => _ScheduleCompleteState();
}

class _ScheduleCompleteState extends State<ScheduleComplete> {
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
                    .collection('MentorData/$mentorUID/Schedule')
                    .orderBy('LectureTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Widget> scheduleCardList = [];
                  if (snapshot.hasData) {
                    scheduleList.clear();
                    final schedules = snapshot.data!.docs;
                    int index = 1;
                    for (var schedule in schedules) {
                      String menteeName = '';
                      for (var mentee in menteesList)
                        if (mentee.uid == schedule.get('MenteeUID')) {
                          menteeName = mentee.fullName;
                          break;
                        }
                      Schedule sch = Schedule(
                        mentee: menteeName,
                        lesson: schedule.get('LessonNumber'),
                        duration: schedule.get('Duration'),
                        timing: schedule.get('LectureTime').toDate(),
                        mentorScheduleID: schedule.id,
                        menteeScheduleID: schedule.get('MenteeScheduleID'),
                        menteeUID: schedule.get('MenteeUID'),
                        postSessionSurvey: schedule.get('PostSessionSurvey'),
                        footNotes: schedule.get('FootNotes'),
                      );
                      scheduleList.add(sch);
                      scheduleCardList.add(
                        ScheduleCard(
                          schedule: sch,
                          index: index++,
                        ),
                      );
                      // }
                    }
                  }
                  return Column(
                    children: [
                      BreakLine(size: size),
                      TotContriLesTauWrapper(schedule: scheduleList),
                      BreakLine(size: size),
                      ...scheduleCardList
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
  final Schedule schedule;
  final int index;
  ScheduleCard({required this.schedule, required this.index});
  @override
  Widget build(BuildContext context) {
    var weekday = DateFormat('EEE d MMMM').format(schedule.timing);
    var lesson = schedule.lesson;
    String startTime = DateFormat('hh:mm').format(schedule.timing);
    startTime = startTime.replaceAll("AM", "am").replaceAll("PM", "pm");
    String endTime = DateFormat('hh:mm a')
        .format(schedule.timing.add(Duration(minutes: schedule.duration)));
    endTime = endTime.replaceAll("AM", "am").replaceAll("PM", "pm");
    bool surveyAvailable = false;
    if (schedule.postSessionSurvey)
      surveyAvailable = false;
    else if (!schedule.postSessionSurvey &&
        schedule.timing
            .add(Duration(minutes: schedule.duration))
            .isBefore(DateTime.now())) {
      surveyAvailable = true;
    }
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
                  height: size.height * 0.27,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Modify Lecture",
                          style: TextStyle(
                              color: kRed.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            color: kLightBlue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Deleted Lectures cannot be restored",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: kLightBlue.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        EditDeleteWrapper(
                          schedule: schedule,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          constraints: BoxConstraints(minHeight: size.height * 0.09),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 40,
                    margin: EdgeInsets.only(right: 5, left: 15),
                    decoration: !surveyAvailable
                        ? BoxDecoration(
                            color: kGreen,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: kBlue.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          )
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kGreen, width: 2),
                          ),
                    child: Center(
                      child: Text(
                        DateFormat('d').format(schedule.timing),
                        style: TextStyle(
                          color: !surveyAvailable ? Colors.white : kGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        minWidth: size.width * 0.30,
                        maxWidth: size.width * 0.30),
                    // width: size.width * 0.34,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.mentee,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "$weekday, lesson $lesson",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          lessonData[schedule.lesson].title,
                          style: TextStyle(
                              fontSize: 11,
                              color: kRed.withOpacity(0.7),
                              fontWeight: FontWeight.bold),
                        ),
                        Visibility(
                          visible: surveyAvailable,
                          child: Column(
                            children: [
                              SizedBox(height: 6),
                              Text(
                                "Survey Available !",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: kGreen.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 14, 5),
                        child: Text(
                          "$startTime - $endTime",
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
                            "  ${schedule.duration} mins",
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
              Visibility(
                visible: schedule.footNotes != '',
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: kBlue.withOpacity(0.15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FootNotes:',
                        style: TextStyle(
                            fontSize: 15,
                            color: kBlue.withOpacity(0.9),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        schedule.footNotes,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TotContriLesTauWrapper extends StatelessWidget {
  final List<Schedule> schedule;
  TotContriLesTauWrapper({
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    Duration totalContribution = getPlannedEngagement(schedule).first;
    String hours = totalContribution.inHours.toString();
    String minutes = totalContribution.inMinutes.remainder(60).toString();
    int plannedLessons = getPlannedEngagement(schedule).last;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PlannedCard(
              heading: "Planned Engagement", value: "${hours}hr ${minutes}min"),
          PlannedCard(
              heading: "Planned Lessons", value: plannedLessons.toString()),
        ],
      ),
    );
  }
}

class PlannedCard extends StatelessWidget {
  final String heading, value;
  PlannedCard({required this.heading, required this.value});
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

class EditDeleteWrapper extends StatelessWidget {
  deleteSchedule(
      String mentorSchID, String menteeUID, String menteeSchID) async {
    await firestore
        .collection('MentorData/$mentorUID/Schedule')
        .doc(mentorSchID)
        .get()
        .then((var value) {
      oldData = {
        'Duration': value.get('Duration'),
        'FootNotes': value.get('FootNotes'),
        'LectureTime': value.get('LectureTime'),
        'LessonNumber': value.get('LessonNumber'),
        'MenteeName': value.get('MenteeName'),
        'MenteeScheduleID': value.get('MenteeScheduleID'),
        'MenteeUID': value.get('MenteeUID'),
        'PostSessionSurvey': value.get('PostSessionSurvey'),
        'MentorName': mentorName,
      };
    });
    firestore
        .collection('MenteeInfo/$menteeUID/Schedule')
        .doc(menteeSchID)
        .delete();
    firestore
        .collection('MentorData/$mentorUID/Schedule')
        .doc(mentorSchID)
        .delete();
    firestore.collection('Logs').add({
      'Event': "Session Deleted",
      'OldData': oldData,
      'NewData': 'Event Deleted',
      'MentorName': mentorName,
      'UID': mentorUID,
      'DateModified': DateTime.now(),
    });
  }

  Schedule schedule;
  EditDeleteWrapper({required this.schedule});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  // Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EditLecture(
                          menteeScheduleID: schedule.menteeScheduleID,
                          mentorScheduleID: schedule.mentorScheduleID,
                          menteeUID: schedule.menteeUID,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "EDIT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  height: size.height * 0.042,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: kLightBlue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: kLightBlue,
                        blurRadius: 10,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  deleteSchedule(schedule.mentorScheduleID, schedule.menteeUID,
                      schedule.menteeScheduleID);
                  Navigator.pop(context);
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "DELETE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  height: size.height * 0.042,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: kRed.withOpacity(0.7),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: kRed.withOpacity(0.7),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PostSessionSurvey(
                      menteeScheduleID: schedule.menteeScheduleID,
                      mentorScheduleID: schedule.mentorScheduleID,
                      menteeUID: schedule.menteeUID,
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "POST SESSION SURVEY",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              height: size.height * 0.042,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.9),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: kGreen.withOpacity(0.9),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
