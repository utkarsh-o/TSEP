import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../local-data/constants.dart';
import '../logic/mentor-cached-data.dart';
import '../logic/mentor-data-processing.dart';

class EditLecture extends StatefulWidget {
  String mentorScheduleID, menteeScheduleID, menteeUID;
  EditLecture(
      {required this.menteeScheduleID,
      required this.mentorScheduleID,
      required this.menteeUID});
  @override
  _EditLectureState createState() => _EditLectureState();
}

Map<String, dynamic> oldData = {}, newData = {};
TimeOfDay pickedTime = TimeOfDay.now();
DateTime pickedDate = DateTime.now();
var footnotesController = TextEditingController();
int pickedDuration = 0, pickedLesson = -1;
String footnotes = "",
    pickedMentee = '',
    menteeScheduleID = '',
    mentorScheduleID = '',
    _menteeUID = '';

class _EditLectureState extends State<EditLecture> {
  final firestore = FirebaseFirestore.instance;

  getData() async {
    await firestore
        .collection('MentorData/$mentorUID/Schedule')
        .doc(widget.mentorScheduleID)
        .get()
        .then((var value) {
      DateTime time = DateTime.fromMicrosecondsSinceEpoch(
          value.get('LectureTime').microsecondsSinceEpoch);
      setState(() {
        pickedTime = TimeOfDay.fromDateTime(time);
        pickedDate = time;
        footnotesController.text = value.get('FootNotes');
        pickedDuration = value.get('Duration');
        pickedLesson = value.get('LessonNumber');
        pickedMentee = value.get('MenteeName');
        oldData = {
          'LectureTime': time,
          'FootNotes': value.get('FootNotes'),
          'Duration': pickedDuration,
          'LessonNumber': pickedLesson,
          'MenteeName': pickedMentee
        };
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    mentorScheduleID = widget.mentorScheduleID;
    menteeScheduleID = widget.menteeScheduleID;
    _menteeUID = widget.menteeUID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TitleBar(),
                MenteeLessonWrapper(),
                TimeDatePickerWrapper(),
                BreakLine(),
                FootNotesWrapper(),
                DurationWrapper(),
                BreakLine(),
                CancelConfirmWrapper(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CancelConfirmWrapper extends StatelessWidget {
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
              DateTime pickedDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute);
              await firestore
                  .collection('/MenteeInfo/$_menteeUID/Schedule')
                  .doc(menteeScheduleID)
                  .update({
                "Duration": pickedDuration,
                "LessonNumber": pickedLesson,
                "LectureTime": Timestamp.fromDate(pickedDateTime),
                "MentorName": mentorName,
                "FootNotes": footnotesController.text,
              });
              firestore
                  .collection('/MentorData/$mentorUID/Schedule')
                  .doc(mentorScheduleID)
                  .update({
                "Duration": pickedDuration,
                "LessonNumber": pickedLesson,
                "LectureTime": Timestamp.fromDate(pickedDateTime),
                "MenteeName": pickedMentee,
                "FootNotes": footnotesController.text,
                "MenteeScheduleID": menteeScheduleID,
                "MenteeUID": _menteeUID
              });
              newData = {
                'Duration': pickedDuration,
                'LessonNumber': pickedLesson,
                'LectureTime': pickedDateTime,
                'MenteeName': pickedMentee,
                'FootNotes': footnotesController.text,
                'MenteeScheduleID': menteeScheduleID,
                'MenteeUID': _menteeUID,
              };
              firestore.collection('Logs').add({
                'Event': 'Edit Lecture Called',
                'OldData': oldData,
                'NewData': newData,
                'UID': mentorUID,
                'MentorName': mentorName,
                'DateModified': DateTime.now(),
              });
              footnotes = "";
              Navigator.of(context).pop(context);
            },
            child: Container(
              child: Center(
                child: Text(
                  "CONFIRM",
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

class _DurationWrapperState extends State<DurationWrapper> {
  callback(Duration dur) {
    setState(() {
      pickedDuration = dur.inMinutes.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DurationNum(duration: Duration(minutes: 30), callback: callback),
              DurationNum(duration: Duration(minutes: 45), callback: callback),
              DurationNum(duration: Duration(hours: 1), callback: callback),
            ],
          ),
        ),
      ],
    );
  }
}

class DurationNum extends StatelessWidget {
  final Duration duration;
  final Function callback;
  DurationNum({required this.callback, required this.duration});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(duration),
      child: Container(
        margin: EdgeInsets.all(7),
        // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        // height: MediaQuery.of(context).size.height * 0.03,
        // width: MediaQuery.of(context).size.width * 0.1,
        decoration: duration.inMinutes == pickedDuration
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
              color: duration.inMinutes == pickedDuration
                  ? Colors.white
                  : Colors.black.withOpacity(0.8),
              fontWeight: duration.inMinutes == pickedDuration
                  ? FontWeight.w700
                  : FontWeight.w600,
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

class FootNotesData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 13),
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
          controller: footnotesController,
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

class _TimeDatePickerWrapperState extends State<TimeDatePickerWrapper> {
  @override
  Widget build(BuildContext context) {
    void datePicker() async {
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

    void timePicker() async {
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
            callback: timePicker,
          ),
          DatePicker(
            callback: datePicker,
          ),
        ],
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final VoidCallback callback;
  DatePicker({required this.callback});
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
  final VoidCallback callback;
  TimePicker({required this.callback});
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

class MenteeLessonWrapper extends StatefulWidget {
  @override
  _MenteeLessonWrapperState createState() => _MenteeLessonWrapperState();
}

String? displayLesson = 'lesson 1';

class _MenteeLessonWrapperState extends State<MenteeLessonWrapper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<int> lessons = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30
    ];
    // List<String> mentees = ['Iron Man'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
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
              ),
              child: Text(
                pickedMentee,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withOpacity(0.8),
                    fontFamily: 'Montserrat'),
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
                menuMaxHeight: 400,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.6),
                    fontFamily: 'Montserrat'),
                isExpanded: true,
                value:
                    pickedLesson != -1 ? 'lesson $pickedLesson' : displayLesson,
                items: lessons.map((int value) {
                  return DropdownMenuItem<String>(
                    child: Text("lesson $value"),
                    value: "lesson $value",
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
            "Modify a Lecture",
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
