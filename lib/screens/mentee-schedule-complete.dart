import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../logic/mentee-cached-data.dart';
import '../logic/mentee-data-processing.dart';
import '../logic/mentee-firestore.dart';
import '../local-data/constants.dart';
import 'mentee-post-session-survey.dart';

final firestore = FirebaseFirestore.instance;
List<Schedule> scheduleList = [];
Map<String, dynamic> oldData = {}, newData = {};

class MenteeScheduleComplete extends StatefulWidget {
  static String route = "ScheduleComplete";

  @override
  _MenteeScheduleCompleteState createState() => _MenteeScheduleCompleteState();
}

class _MenteeScheduleCompleteState extends State<MenteeScheduleComplete> {
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
                    .collection('MenteeInfo/$menteeUID/Schedule')
                    .orderBy('LectureTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Widget> scheduleCardList = [];
                  if (snapshot.hasData) {
                    scheduleList.clear();
                    final schedules = snapshot.data!.docs;
                    int index = 1;
                    for (var schedule in schedules) {
                      Schedule sch = Schedule(
                        mentor: mentorProfileData.fullName,
                        lesson: schedule.get('LessonNumber'),
                        duration: schedule.get('Duration'),
                        timing: schedule.get('LectureTime').toDate(),
                        menteeScheduleID: schedule.id,
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
    var weekday = DateFormat('EEE, d MMMM').format(schedule.timing);
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
                  height: size.height * 0.18,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            color: kRed.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Please fill the survey with utmost sincerity",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: kRed.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        SurveyWrapper(
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
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: size.width * 0.34,
                          minWidth: size.width * 0.3),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lesson $lesson',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "$weekday",
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
                                    fontSize: 11,
                                    color: kGreen.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: size.width * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$startTime - $endTime",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              color: kGreen.withOpacity(0.8),
                              size: 12,
                            ),
                            Text(
                              "  ${schedule.duration} mins",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kGreen.withOpacity(0.8),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
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
              heading: "Total Lesson Duration",
              value: "${hours}hr ${minutes}min"),
          PlannedCard(
              heading: "Total Lessons", value: plannedLessons.toString()),
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

class SurveyWrapper extends StatelessWidget {
  Schedule schedule;
  SurveyWrapper({required this.schedule});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MenteePostSessionSurvey(
                  menteeScheduleID: schedule.menteeScheduleID,
                );
              },
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
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
    );
  }
}
