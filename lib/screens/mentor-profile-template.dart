import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/components/CustomNavigationBar.dart';
import 'package:tsep/local-data/line_titles.dart';
import 'package:tsep/screens/login-page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentorProfileTemplate extends StatefulWidget {
  const MentorProfileTemplate({Key? key}) : super(key: key);

  @override
  _MentorProfileTemplateState createState() => _MentorProfileTemplateState();
}

class _MentorProfileTemplateState extends State<MentorProfileTemplate> {
  final auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void editbtncbk() {
    auth.signOut();
    Navigator.push(
      (context),
      MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      ),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleBar(callback: editbtncbk),
            MentorProfileBanner(),
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
      bottomNavigationBar: CustomBottomNavBar(active: 0),
    );
  }
}

// class ActivityPlot extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 15),
//       child: SvgPicture.asset(
//         'assets/vectors/mentor-graph.svg',
//         width: size.width * 0.95,
//       ),
//     );
//   }
// }

class ActivityPlot extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff1F78B4),
    const Color(0xff1F78B4),
  ];
  final List<Color> gradientColors2 = [
    const Color(0xffD92136).withOpacity(0.7),
    const Color(0xffD92136).withOpacity(0.7),
    // const Color(0xffD92136),
  ];
  List<LineChartBarData> linechartbardata() {
    final lessons = LineChartBarData(
      spots: [
        FlSpot(1, 3),
        FlSpot(2, 2),
        FlSpot(3, 2),
        FlSpot(4, 1),
        FlSpot(5, 1),
        FlSpot(6, 4),
        FlSpot(7, 3),
        FlSpot(8, 2),
        FlSpot(9, 2),
        FlSpot(10, 3),
      ],
      curveSmoothness: 0.6,
      isCurved: true,
      colors: gradientColors,
      preventCurveOverShooting: true,
      barWidth: 4,
      dotData: FlDotData(
        show: false,
      ),
      shadow: BoxShadow(
        blurRadius: 6,
        color: Color(0xff1F78B4),
      ),
    );
    final hours = LineChartBarData(
        show: true,
        spots: [
          FlSpot(1, 2.7),
          FlSpot(2, 2.4),
          FlSpot(3, 2.1),
          FlSpot(4, 1.7),
          FlSpot(5, 1.3),
          FlSpot(6, 3.9),
          FlSpot(7, 3.2),
          FlSpot(8, 1.5),
          FlSpot(9, 2.1),
          FlSpot(10, 3),
        ],
        isCurved: true,
        colors: gradientColors2,
        curveSmoothness: 0.6,
        preventCurveOverShooting: true,
        barWidth: 4,
        dotData: FlDotData(
          show: false,
        ),
        shadow: BoxShadow(
            blurRadius: 6, color: Color(0xffD92136).withOpacity(0.85)));
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Text(
            "Mentor Profile",
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
        InkWell(
          onTap: callback,
          child: SvgPicture.asset(
            "assets/icons/edit-tb.svg",
            height: screenWidth * 0.06,
          ),
        )
      ],
    );
  }
}

class MentorProfileBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // margin: EdgeInsets.only(right: size.width * 0.02),
            height: double.infinity,
            width: size.height * 0.16,
            child: Image.asset("assets/vectors/Mentor(F).png"),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Text(
                  "Sneha Khanna",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "joined 10 Apr 2021",
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
                      "2",
                      style: TextStyle(
                          color: Color(0xff003670).withOpacity(0.6),
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
                      "19 hours",
                      style: TextStyle(
                          color: Color(0xff34A853).withOpacity(0.6),
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
                      "27 hours",
                      style: TextStyle(
                          color: Color(0xff34A853).withOpacity(0.6),
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
                      "5 May 2021",
                      style: TextStyle(
                          color: Color(0xffD92136).withOpacity(0.6),
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
                      "4 / 2.5",
                      style: TextStyle(
                          color: Color(0xffD92136).withOpacity(0.6),
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
    );
  }
}

class OrgIDNumCard extends StatelessWidget {
  const OrgIDNumCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InsideCard(heading: "Organization", value: "Individual"),
          InsideCard(heading: "Identification Number", value: "007"),
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
            color: Color(0xff003670).withOpacity(0.1),
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
          Container(
            margin: EdgeInsets.only(top: 20),
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
              color: Color(0xff1F78B4),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1F78B4),
                  blurRadius: 10,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
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
              color: Color(0xffD92136).withOpacity(0.7),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffD92136).withOpacity(0.7),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
