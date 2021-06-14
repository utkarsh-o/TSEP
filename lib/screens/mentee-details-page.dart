import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenteeDetails extends StatelessWidget {
  const MenteeDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleBar(),
            MenteeProfile(),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BatchJoinProfAgeWidget(
                    heading: 'Batch',
                    value: "B01",
                  ),
                  BatchJoinProfAgeWidget(
                    heading: 'Joining Proficiency',
                    value: "Novice",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            // BreakLine(),
            Expanded(
              child: ListView(
                children: [
                  LessonList(
                    lesson: 1,
                    lessonLength: "40 mins",
                    date: "18 May",
                  ),
                  LessonList(
                    lesson: 2,
                    lessonLength: "21 mins",
                    date: "21 May",
                  ),
                  LessonList(
                    lesson: 3,
                    lessonLength: "1hr 08 mins",
                    date: "24 May",
                  ),
                  LessonList(
                    lesson: 4,
                    lessonLength: "33 mins",
                    date: "27 May",
                  ),
                  LessonList(
                    lesson: 5,
                    lessonLength: "42 mins",
                    date: "30 May",
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
  final int lesson;
  final String date, lessonLength;
  LessonList(
      {required this.lesson, required this.date, required this.lessonLength});
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
                  "$lesson",
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
                      fontSize: 15,
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
                "$lessonLength",
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

class MenteeProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: size.height * 0.15,
            width: size.height * 0.15,
            child: Image.asset("assets/vectors/mentee-profile.png"),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: double.infinity,
                child: Text(
                  "Mentee-1",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "joined 17 may 2021",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "+91 9876543210",
                  style: TextStyle(
                      color: Color(0xff269200),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: EngLessonCards(
                      heading: "Engagement",
                      value: "3hr 40min",
                      valueColor: Color(0xffD92136).withOpacity(0.6),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Container(
                    child: EngLessonCards(
                      heading: "Lessons",
                      value: "5",
                      valueColor: Color(0xff1F78B4).withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BatchJoinProfAgeWidget extends StatelessWidget {
  final String heading, value;
  BatchJoinProfAgeWidget({required this.heading, required this.value});
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
      margin: EdgeInsets.only(top: 10),
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
