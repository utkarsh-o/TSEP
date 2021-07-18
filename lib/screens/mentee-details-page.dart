import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../local-data/constants.dart';
import '../logic/mentor-cached-data.dart';
import '../screens/pre-test-screen.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class MenteeDetails extends StatefulWidget {
  String menteeUID;
  MenteeDetails({required this.menteeUID});

  @override
  _MenteeDetailsState createState() => _MenteeDetailsState();
}

String firstName = '',
    lastName = '',
    batchName = '',
    gender = '',
    initialLevel = '',
    menteeName = '',
    menteeUID = '';
int phoneNumber = -1, idNumber = -1, whatsappNumber = -1;
num engagement = 0;
DateTime joiningDate = DateTime.now();

class _MenteeDetailsState extends State<MenteeDetails> {
  @override
  void initState() {
    super.initState();
    getMenteeDetails();
    getDataStream();
  }

  getDataStream() async {
    await for (var snapshot in firestore
        .collection('MenteeInfo')
        .doc(widget.menteeUID)
        .snapshots()) {
      if (mounted) {
        setState(() {
          batchName = snapshot.get('BatchName').toString();
          firstName = snapshot.get('FirstName').toString();
          idNumber = snapshot.get('IDNumber');
          lastName = snapshot.get('LastName').toString();
          joiningDate = snapshot.get('JoiningDate').toDate();
          gender = snapshot.get('Gender');
          phoneNumber = snapshot.get('PhoneNumber');
          whatsappNumber = snapshot.get('WhatsappNumber');
          initialLevel = snapshot.get('InitialLevel');
          menteeName = "$firstName $lastName";
        });
      }
    }
  }

  getMenteeDetails() {
    for (var mentee in menteesList) {
      if (mentee.uid == widget.menteeUID) {
        setState(() {
          menteeUID = mentee.uid;
          batchName = mentee.batchName;
          firstName = mentee.firstName;
          idNumber = mentee.idNumber;
          lastName = mentee.lastName;
          joiningDate = mentee.joiningDate;
          gender = mentee.gender;
          phoneNumber = mentee.phoneNumber;
          whatsappNumber = mentee.whatsappNumber;
          initialLevel = mentee.initialLevel;
          menteeName = mentee.fullName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TitleBar(),
              StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('MentorData/$mentorUID/Schedule')
                    .orderBy('LectureTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (initialLevel == 'TBD') {
                    return Column(
                      children: [
                        _MenteeProfile(
                          lessonsScheduled: 0,
                        ),
                        SizedBox(height: size.height * 0.02),
                        BatchJoinProfWrapper(),
                        SizedBox(height: size.height * 0.02),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TestScreen(
                                menteeUID: menteeUID,
                              );
                            }));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                "Take Pre-Program Test",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            height: size.height * 0.08,
                            width: size.width * 0.6,
                            decoration: BoxDecoration(
                              color: kLightBlue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: kLightBlue,
                                  blurRadius: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  List<Widget> lessonList = [];
                  int index = 1;
                  if (snapshot.hasData) {
                    engagement = 0;
                    final lessons = snapshot.data!.docs;
                    for (var lesson in lessons) {
                      if (lesson.get('MenteeUID') == widget.menteeUID) {
                        engagement += lesson.get('Duration');
                        lessonList.add(LessonList(
                            index: index++,
                            lesson: lesson.get('LessonNumber'),
                            date: DateFormat('EEE, d MMMM')
                                .format(lesson.get('LectureTime').toDate()),
                            lessonLength: lesson.get('Duration').toString()));
                      }
                    }
                  }
                  return Column(
                    children: [
                      _MenteeProfile(
                        lessonsScheduled: index > 0 ? index - 1 : index,
                      ),
                      SizedBox(height: size.height * 0.02),
                      BatchJoinProfWrapper(),
                      SizedBox(height: size.height * 0.02),
                      ...lessonList,
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BatchJoinProfWrapper extends StatelessWidget {
  const BatchJoinProfWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TestScreen(
                menteeUID: menteeUID,
              );
            }));
          },
          child: BatchJoinProfIDWidget(
            heading: 'Batch',
            value: batchName,
          ),
        ),
        BatchJoinProfIDWidget(
          heading: 'Joining Proficiency',
          value: initialLevel,
        ),
        BatchJoinProfIDWidget(
          heading: 'ID Number',
          value: idNumber.toString(),
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
      height: 3,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
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

class LessonList extends StatelessWidget {
  final date, lessonLength;
  final int index, lesson;
  LessonList(
      {required this.lesson,
      required this.date,
      required this.lessonLength,
      required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
        // width: size.width * 0.75,
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
                  index.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 100),
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lesson $lesson",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "$date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "$lessonLength minutes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff003670),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenteeProfile extends StatelessWidget {
  int lessonsScheduled;
  _MenteeProfile({required this.lessonsScheduled});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: gender == 'male'
                  ? Image.asset(
                      "assets/vectors/Mentee(M)normal"
                      ".png",
                      scale: 2,
                    )
                  : Image.asset(
                      "assets/vectors/Mentee(F)normal.png",
                      scale: 2,
                    ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 50,
                  )
                ],
              ),
            ),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$firstName $lastName",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8)),
                        ),
                        Text(
                          "joined ${DateFormat('d MMMM yyyy').format(joiningDate)}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ]),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: kGreen,
                        size: 16,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        "$phoneNumber",
                        style: TextStyle(
                            color: Color(0xff269200),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Icon(
                        Icons.message,
                        color: kGreen,
                        size: 16,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        "$whatsappNumber",
                        style: TextStyle(
                            color: Color(0xff269200),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: EngLessonCards(
                          heading: "Engagement",
                          value:
                              "${(engagement / 60).floor()}hr ${engagement % 60}min",
                          valueColor: Color(0xffD92136).withOpacity(0.6),
                        ),
                      ),
                      Container(
                        child: EngLessonCards(
                          heading: "Lessons",
                          value: lessonsScheduled.toString(),
                          valueColor: kLightBlue.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BatchJoinProfIDWidget extends StatelessWidget {
  final String heading, value;
  BatchJoinProfIDWidget({required this.heading, required this.value});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

class EngLessonCards extends StatelessWidget {
  final String heading, value;
  final Color valueColor;
  EngLessonCards(
      {required this.heading, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          SizedBox(
            height: size.height * 0.007,
          ),
          Text(
            value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
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
            "Mentee Details",
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
