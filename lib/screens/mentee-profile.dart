import 'dart:core';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/mentee-customNavigationBar.dart';
import '../local-data/constants.dart';
import '../local-data/line_titles.dart';
import '../logic/authentication.dart';
import '../logic/mentee-cached-data.dart';
import '../logic/mentee-data-processing.dart';
import '../logic/mentee-firestore.dart';

class MenteeProfile extends StatefulWidget {
  static String route = "MenteeProfile";

  @override
  _MenteeProfileState createState() => _MenteeProfileState();
}

String firstName = '',
    email = '',
    lastName = '',
    batchName = '',
    organization = '',
    uid = '',
    gender = '',
    lastInteraction = '',
    nextInteraction = '',
    mentorName = '',
    mentorEmail = '';
double lecturesPerWeek = 0, hoursPerWeek = 0;
int idNumber = 0,
    mentees = 0,
    mentorIDNumber = -1,
    mentorPhoneNumber = -1,
    mentorWhatsappNumber = -1;
DateTime JoiningDate = DateTime.now();
bool mentorAssigned = false;
final firestore = MenteeProfileHandler();

class _MenteeProfileState extends State<MenteeProfile> {
  String email = '', password = '';

  @override
  void initState() {
    super.initState();
    firestore.getData(parseData);
  }

  parseMenteeProfileData() {
    if (this.mounted)
      setState(() {
        batchName = menteeProfileData.batchName;
        firstName = menteeProfileData.firstName;
        idNumber = menteeProfileData.idNumber;
        lastName = menteeProfileData.lastName;
        organization = menteeProfileData.organization;
        email = menteeProfileData.email;
        JoiningDate = menteeProfileData.joiningDate;
        gender = menteeProfileData.gender;
      });
  }

  parseMenteeScheduleData() {
    setState(() {
      lastInteraction =
          formatLastInteraction(menteeScheduleData.lastInteraction);
      nextInteraction =
          formatNextInteraction(menteeScheduleData.nextInteraction);
      hoursPerWeek = menteeScheduleData.hoursPerWeek;
      lecturesPerWeek = menteeScheduleData.lecturesPerWeek;
    });
  }

  parseMentorProfileData() {
    if (mentorProfileData.firstName == '-')
      setState(() {
        mentorAssigned = false;
      });
    else {
      setState(() {
        mentorAssigned = true;
        mentorName = mentorProfileData.fullName;
        mentorIDNumber = mentorProfileData.idNumber;
        mentorPhoneNumber = mentorProfileData.phoneNumber;
        mentorWhatsappNumber = mentorProfileData.whatsappNumber;
        mentorEmail = mentorProfileData.email;
      });
    }
  }

  parseData() {
    if (this.mounted) {
      setState(() {
        parseMenteeProfileData();
        parseMenteeScheduleData();
        parseMentorProfileData();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleBar(callback: logoutCallback),
            MenteeProfileBanner(),
            OrgIDNumCard(),
            BreakLine(),
            MentorProfileBanner(),
            BreakLine(),
            ActivityPlot(),
            Text(
              "Weeks vs Hours/Lessons".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MenteeCustomBottomNavBar(active: 0),
    );
  }
}

class MentorProfileBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return mentorAssigned
        ? Container(
            // margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Mentor',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.0025,
                        ),
                        Text(
                          mentorProfileData.fullName,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    DetailsWidget(
                        heading: "Batch", value: menteeProfileData.batchName),
                    DetailsWidget(
                        heading: "ID Number",
                        value: mentorProfileData.idNumber.toString()),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Phone Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${mentorProfileData.phoneNumber}',
                          style: TextStyle(
                            color: kGreen.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Whatsapp Phone',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${mentorProfileData.whatsappNumber}',
                          style: TextStyle(
                            color: kGreen.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Text(
              'Please wait patiently while a mentor is being assigned to you',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kRed.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          );
  }
}

class DetailsWidget extends StatelessWidget {
  final String heading, value;
  DetailsWidget({required this.heading, required this.value});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          heading,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height * 0.005,
        ),
        Text(
          value,
          style: TextStyle(
            color: kRed.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
      spots: getMenteeLessonChartData(JoiningDate),
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
      spots: getMenteeHourChartData(JoiningDate),
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
        margin: EdgeInsets.only(right: 20, top: 10),
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
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.1, vertical: size.height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              "Mentee Profile",
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

class MenteeProfileBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String formattedJoiningDate =
        DateFormat(' d MMMM yyyy').format(menteeProfileData.joiningDate);
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
                  ? Image.asset("assets/vectors/Mentee(M)happy.png")
                  : Image.asset("assets/vectors/Mentee(F)happy.png"),
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
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InsideCard(heading: "Organization", value: "$organization"),
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
      margin: EdgeInsets.symmetric(vertical: 15),
      height: 1,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
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
