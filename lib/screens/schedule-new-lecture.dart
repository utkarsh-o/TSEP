import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../local-data/constants.dart';
import '../logic/cached-data.dart';
import '../logic/data-processing.dart';

class ScheduleNew extends StatefulWidget {
  @override
  _ScheduleNewState createState() => _ScheduleNewState();
}

String DisplayName = '';
String? displayLesson = 'lesson 1';
int pickedLesson = 1;
String? pickedMentee = 'Iron Man';
Map<String, dynamic> oldData = {}, newData = {};

class _ScheduleNewState extends State<ScheduleNew> {
  @override
  void initState() {
    super.initState();
    if (menteesList.length >= 1) {
      setState(() {
        pickedTime = TimeOfDay.now();
        pickedDate = DateTime.now();
        footnotescontroller.clear();
        pickedLesson = 1;
        pickedDuration = 30;
        displayLesson = 'lesson 1';
        DisplayName =
            "${menteesList.first.firstName} ${menteesList.first.lastName}";
        pickedMentee = DisplayName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: menteesList.length < 1
            ? Container(
                margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.2, horizontal: size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Scheduling new lectures can be done after the allotment of at least 1 mentee",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SpinKitSquareCircle(
                      color: Color(0xff003670).withOpacity(0.5),
                      size: 70,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(size.shortestSide * 0.05),
                        child: Center(
                          child: Text(
                            "EXIT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: kRed.withOpacity(0.7),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
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
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TitleBar(),
                      MntLsnCards(),
                      TimeDatePickerWrapper(),
                      BreakLine(),
                      FootNotesWrapper(),
                      DurationWrapper(),
                      BreakLine(),
                      CancleScheduleBtn(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class CancleScheduleBtn extends StatelessWidget {
  @override
  final firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Center(
                child: Text(
                  "CANCEL",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              height: size.height * 0.07,
              width: size.width * 0.4,
              decoration: BoxDecoration(
                color: Color(0xffD92136).withOpacity(0.7),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD92136).withOpacity(0.7),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String mentorSchID = '', menteeSchID = '';
              DateTime pickedDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute);

              String menteeUID = '';
              menteesList.forEach((mentee) {
                if (mentee.fullName == pickedMentee) menteeUID = mentee.uid;
              });
              await firestore
                  .collection('/MenteeInfo/$menteeUID/Schedule')
                  .add({
                "Duration": pickedDuration,
                "LessonNumber": pickedLesson,
                "LectureTime": Timestamp.fromDate(pickedDateTime),
                "MentorName": mentorName,
                "FootNotes": footnotes,
                "PostSessionSurvey": false,
              }).then((var value) => menteeSchID = value.id);
              firestore.collection('/MentorData/$mentorUID/Schedule').add({
                "Duration": pickedDuration,
                "LessonNumber": pickedLesson,
                "LectureTime": Timestamp.fromDate(pickedDateTime),
                "MenteeName": pickedMentee,
                "FootNotes": footnotes,
                "MenteeScheduleID": menteeSchID,
                "MenteeUID": menteeUID,
                "PostSessionSurvey": false,
              }).then((value) => mentorSchID = value.id);
              firestore.collection('Logs').add({
                'Event': "New Session Scheduled",
                'OldData': "Does not exist",
                'NewData': {
                  "Duration": pickedDuration,
                  "LessonNumber": pickedLesson,
                  "LectureTime": Timestamp.fromDate(pickedDateTime),
                  "MenteeName": pickedMentee,
                  "FootNotes": footnotes,
                  "MenteeScheduleID": menteeSchID,
                  "MenteeUID": menteeUID,
                  "PostSessionSurvey": false,
                },
                'MentorName': mentorName,
                'UID': mentorUID,
                'DateModified': DateTime.now(),
              });
              footnotes = "";
              Navigator.of(context).pop(context);
            },
            child: Container(
              child: Center(
                child: Text(
                  "SCHEDULE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              height: size.height * 0.07,
              width: size.width * 0.4,
              decoration: BoxDecoration(
                color: kLightBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: kLightBlue,
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

class DurationWrapper extends StatefulWidget {
  @override
  _DurationWrapperState createState() => _DurationWrapperState();
}

int pickedDuration = 0;

class _DurationWrapperState extends State<DurationWrapper> {
  Duration active = Duration(minutes: 30);

  @override
  Widget build(BuildContext context) {
    void callback(Duration dur) {
      setState(
        () {
          active = dur;
          pickedDuration = dur.inMinutes.toInt();
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Duration",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff34A853).withOpacity(0.3),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6),
          ),
          // height: size.height * 0.045,
          // width: size.width * 0.65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DurationNum(
                  duration: Duration(minutes: 30),
                  active: active,
                  callback: callback),
              DurationNum(
                  duration: Duration(minutes: 45),
                  active: active,
                  callback: callback),
              DurationNum(
                  duration: Duration(hours: 1),
                  active: active,
                  callback: callback),
            ],
          ),
        ),
      ],
    );
  }
}

class DurationNum extends StatelessWidget {
  final Duration duration, active;
  final Function callback;

  DurationNum(
      {required this.active, required this.callback, required this.duration});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(duration),
      child: Container(
        margin: EdgeInsets.all(7),
        // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        // height: MediaQuery.of(context).size.height * 0.03,
        // width: MediaQuery.of(context).size.width * 0.1,
        decoration: active == duration
            ? BoxDecoration(
                color: Color(0xff34A853).withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text(
            "${duration.inMinutes} mins",
            // textAlign: TextAlign.center,
            style: TextStyle(
              color: active == duration
                  ? Colors.white
                  : Colors.black.withOpacity(0.8),
              fontWeight:
                  active == duration ? FontWeight.w700 : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class FootNotesWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "FootNotes",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          FootNotesData(),
        ],
      ),
    );
  }
}

String footnotes = "";
final footnotescontroller = TextEditingController();

class FootNotesData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 13),
      // alignment: Alignment.center,
      height: size.height * 0.25,
      width: size.width * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: kLightBlue.withOpacity(0.8), width: 3),
        boxShadow: [
          BoxShadow(
            color: kLightBlue.withOpacity(0.7),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: footnotescontroller,
          onChanged: (value) => footnotes = value,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          expands: true,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class TimeDatePickerWrapper extends StatefulWidget {
  @override
  _TimeDatePickerWrapperState createState() => _TimeDatePickerWrapperState();
}

DateTime pickedDate = DateTime.now();
TimeOfDay pickedTime = TimeOfDay.now();

class _TimeDatePickerWrapperState extends State<TimeDatePickerWrapper> {
  @override
  Widget build(BuildContext context) {
    void datepicker() async {
      DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
      );
      if (date != null) {
        setState(() {
          pickedDate = date;
        });
      }
    }

    void timepicker() async {
      TimeOfDay? time =
          await showTimePicker(context: context, initialTime: pickedTime);
      if (time != null) {
        setState(() {
          pickedTime = time;
        });
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TimePicker(
            callback: timepicker,
            pickedTime: pickedTime,
          ),
          DatePicker(
            callback: datepicker,
            pickedDate: pickedDate,
          ),
        ],
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final VoidCallback callback;
  final DateTime pickedDate;

  DatePicker({required this.callback, required this.pickedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            "Date",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
          InkWell(
            onTap: callback,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 13),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color(0xffD92136).withOpacity(0.7),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD92136).withOpacity(0.7),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                DateFormat('EEE, MMM d').format(pickedDate),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.6),
                  // fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimePicker extends StatelessWidget {
  @override
  final VoidCallback callback;
  final TimeOfDay pickedTime;

  TimePicker({required this.callback, required this.pickedTime});

  Widget build(BuildContext context) {
    String formatTimeOfDay(TimeOfDay tod) {
      final now = new DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      final format = DateFormat.jm(); //"6:00 AM"
      return format.format(dt);
    }

    return Container(
      child: Row(
        children: [
          Text(
            "Time",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
          ),
          InkWell(
            onTap: callback,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 13),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color(0xffD92136).withOpacity(0.7),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD92136).withOpacity(0.7),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                formatTimeOfDay(pickedTime),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.6),
                  // fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MntLsnCards extends StatefulWidget {
  @override
  _MntLsnCardsState createState() => _MntLsnCardsState();
}

class _MntLsnCardsState extends State<MntLsnCards> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<int> lessons = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    // List<String> mentees = ['Iron Man'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mentee",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16),
            ),
            Container(
              width: size.width * 0.4,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color(0xffD92136).withOpacity(0.7),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD92136).withOpacity(0.7),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: DropdownButton(
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.6),
                    fontFamily: 'Montserrat'),
                isExpanded: true,
                value: DisplayName,
                items: menteesList.map((value) {
                  return DropdownMenuItem<String>(
                    child: Text(value.fullName),
                    value: value.fullName,
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    pickedMentee = value;
                    DisplayName = value ?? "test";
                  });
                },
                underline: Container(
                  height: 0,
                ),
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lessons",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16),
            ),
            Container(
              width: size.width * 0.4,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color(0xffD92136).withOpacity(0.7),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffD92136).withOpacity(0.7),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: DropdownButton(
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.6),
                    fontFamily: 'Montserrat'),
                isExpanded: true,
                value: displayLesson,
                items: lessons.map((int value) {
                  return DropdownMenuItem<String>(
                    child: Text('lesson $value'),
                    value: 'lesson $value',
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    pickedLesson = parseIntFromString(value ?? '1');
                    displayLesson = value;
                  });
                },
                underline: Container(
                  height: 0,
                ),
              ),
            )
          ],
        ),
      ],
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
            "Schedule a Lecture",
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

class BreakLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
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
