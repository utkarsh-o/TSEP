import 'dart:core';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/mentor-customNavigationBar.dart';
import '../local-data/constants.dart';
import '../local-data/line_titles.dart';
import '../logic/authentication.dart';
import '../logic/mentor-cached-data.dart';
import '../logic/mentor-data-processing.dart';
import '../logic/mentor-firestore.dart';
import '../screens/declare-completion.dart';
import '../screens/report-dropout.dart';

class MentorProfile extends StatefulWidget {
  static String route = "MentorProfile";

  @override
  _MentorProfileState createState() => _MentorProfileState();
}

String firstName = '',
    email = '',
    lastName = '',
    batchName = '',
    category = '',
    uid = '',
    gender = '',
    lastInteraction = '',
    nextInteraction = '';
double lecturesPerWeek = 0, hoursPerWeek = 0;
int idNumber = 0, mentees = 0;
DateTime JoiningDate = DateTime.now();
final firestore = ProfileHandler();

class _MentorProfileState extends State<MentorProfile> {
  String email = '', password = '';

  @override
  void initState() {
    super.initState();
    firestore.getData(parseData);
  }

  parseMentorProfileData() {
    setState(() {
      batchName = mentorProfileData.batchName;
      firstName = mentorProfileData.firstName;
      idNumber = mentorProfileData.idNumber;
      lastName = mentorProfileData.lastName;
      category = mentorProfileData.category;
      email = mentorProfileData.email;
      JoiningDate = mentorProfileData.joiningDate;
      gender = mentorProfileData.gender;
      mentees = menteesList.length;
    });
  }

  parseMentorScheduleData() {
    setState(() {
      lastInteraction =
          formatLastInteraction(mentorScheduleData.lastInteraction);
      nextInteraction =
          formatNextInteraction(mentorScheduleData.nextInteraction);
      hoursPerWeek = mentorScheduleData.hoursPerWeek;
      lecturesPerWeek = mentorScheduleData.lecturesPerWeek;
    });
  }

  parseData() {
    if (this.mounted) {
      setState(() {
        parseMentorProfileData();
        parseMentorScheduleData();
      });
    }
  }

  Widget build(BuildContext context) {
    void logoutCallback() {
      final auth = Authentication();
      auth.signoutUser();
      Navigator.pushReplacementNamed(context, '/');
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleBar(callback: logoutCallback),
              MentorProfileBanner(joiningDate: mentorProfileData.joiningDate),
              OrgIDNumCard(),
              BreakLine(),
              ActivityPlot(),
              Text(
                "Weeks vs Hours/Lessons".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              BreakLine(),
              DecComRepDropContainer()
            ],
          ),
        ),
      ),
      bottomNavigationBar: MentorCustomBottomNavBar(active: 0),
    );
  }
}

class ActivityPlot extends StatelessWidget {
  final List<Color> lessonBlueGradient = [
    const Color(0xff1F78B4),
    const Color(0xff1F78B4),
  ];
  final List<Color> hoursRedGradient = [
    const Color(0xffD92136).withOpacity(0.7),
    const Color(0xffD92136).withOpacity(0.7),
  ];

  List<LineChartBarData> linechartbardata() {
    final lessons = LineChartBarData(
      spots: getMentorLessonChartData(JoiningDate),
      curveSmoothness: 0.6,
      isCurved: true,
      colors: lessonBlueGradient,
      preventCurveOverShooting: true,
      barWidth: 4,
      dotData: FlDotData(
        show: false,
      ),
      shadow: BoxShadow(
        blurRadius: 6,
        color: kLightBlue,
      ),
    );
    final hours = LineChartBarData(
      show: true,
      spots: getMentorHourChartData(JoiningDate),
      isCurved: true,
      colors: hoursRedGradient,
      curveSmoothness: 0.6,
      preventCurveOverShooting: true,
      barWidth: 4,
      dotData: FlDotData(
        show: false,
      ),
      shadow: BoxShadow(
        blurRadius: 6,
        color: kRed.withOpacity(0.85),
      ),
    );
    return [lessons, hours];
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(left: 10, right: 20, top: 20),
        height: MediaQuery.of(context).size.height * 0.20,
        child: LineChart(
          LineChartData(
            minX: 1,
            maxX: 10,
            minY: 0,
            maxY: 4,
            titlesData: LineTitles.getTitleData(),
            gridData: FlGridData(
              show: false,
              drawHorizontalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Color(0xff37434d),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: linechartbardata(),
          ),
        ),
      );
}

class TitleBar extends StatelessWidget {
  final VoidCallback callback;

  TitleBar({required this.callback});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 35, vertical: size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              "Mentor Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
          ),
          InkWell(
            onTap: callback,
            child: Container(
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
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MentorProfileBanner extends StatelessWidget {
  final DateTime joiningDate;

  MentorProfileBanner({required this.joiningDate});

  @override
  Widget build(BuildContext context) {
    String formattedJoiningDate =
        DateFormat(' d MMMM yyyy').format(joiningDate);
    String formattedEndDate =
        DateFormat(' d MMMM').format(JoiningDate.add(Duration(days: 70)));
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: gender == 'female' ? size.width * 0.3 : size.width * 0.25,
              child: gender == 'male'
                  ? Image.asset("assets/vectors/Mentor(M).png")
                  : Image.asset("assets/vectors/Mentor(F).png"),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "$firstName $lastName",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "joined $formattedJoiningDate",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        "Mentees",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        mentees.toString(),
                        style: TextStyle(
                            color: kBlue.withOpacity(0.6),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text(
                        "Last interaction",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "$lastInteraction",
                        style: TextStyle(
                            color: kGreen.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text(
                        "Next interaction",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        nextInteraction,
                        style: TextStyle(
                            color: kGreen.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text(
                        "Expected End of Program",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "$formattedEndDate",
                        style: TextStyle(
                            color: kRed.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text(
                        "Required Lct/Hr per week",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "$lecturesPerWeek / $hoursPerWeek",
                        style: TextStyle(
                            color: kRed.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrgIDNumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InsideCard(heading: "Organization", value: "$category"),
          InsideCard(
              heading: "ID Number /Batch ", value: "$idNumber / $batchName"),
        ],
      ),
    );
  }
}

class InsideCard extends StatelessWidget {
  final String heading, value;

  InsideCard({required this.heading, required this.value});

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
            value.toUpperCase(),
            style: TextStyle(
              color: kRed.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class BreakLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      height: 1,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: kBlue.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class DecComRepDropContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DeclareCompletion(firestore: firestore);
              }));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  "DECLARE\nCOMPLETION",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              height: size.height * 0.08,
              width: size.width * 0.4,
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
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ReportDropout(
                      firestore: firestore,
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  "REPORT\nDROPOUT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              height: size.height * 0.08,
              width: size.width * 0.4,
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
    );
  }
}
