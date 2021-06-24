import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/CustomNavigationBar.dart';
import '../local-data/constants.dart';
import '../logic/firestore.dart';
import '../screens/FAQ-page.dart';
import '../screens/guidelines-page.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getLessonList() {
      List<Widget> lessonList = [];
      for (var index = 0; index < lessonData.length; index++) {
        lessonList.add(
          LessonCard(
            index: index + 1,
            lesson: lessonData[index],
          ),
        );
      }
      return Column(children: lessonList);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBar(),
              FAQGuidelineCards(),
              BreakLine(),
              ResourcesText(),
              getLessonList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        active: 3,
      ),
    );
  }
}

class ResourcesText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.only(left: size.width * 0.08, bottom: size.height * 0.04),
      child: Text(
        "Resources",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.5),
          fontSize: 18,
        ),
      ),
    );
  }
}

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.1, vertical: size.height * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQGuidelineCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            splashColor: Color(0xffD92136).withOpacity(0),
            highlightColor: Color(0xffD92136).withOpacity(0),
            onTap: () {
              Navigator.pushNamed(context, FAQPage.route);
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/faq.svg',
                      width: size.height * 0.04,
                    ),
                    Text(
                      "FAQ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              height: size.height * 0.14,
              width: size.width * 0.3,
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
            splashColor: kRed.withOpacity(0),
            highlightColor: kRed.withOpacity(0),
            onTap: () {
              Navigator.pushNamed(context, GuidelinesPage.route);
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/guidelines.svg',
                      width: size.height * 0.04,
                    ),
                    Text(
                      "GUIDELINES",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              height: size.height * 0.14,
              width: size.width * 0.3,
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
            color: kLightBlue.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final int index;
  final Lesson lesson;
  LessonCard({required this.lesson, required this.index});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        print(lesson.url);
        _openPDF(lesson.url, context);
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
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
          width: size.width * 0.85,
          height: size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: size.width * 0.06),
                height: 35,
                width: 40,
                decoration: BoxDecoration(
                  color: kBlue.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: kBlue.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "$index",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lesson $index",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "${lesson.title}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: size.width * 0.06),
                child: Text(
                  "${lesson.duration}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_openPDF(String url, BuildContext context) async {
  print(url);
  if (await canLaunch(url))
    await launch(url);
  else {
    showSnackBar(context, 'Could not open document, please retry later.');
    throw "Could not launch $url";
  }
}

void showSnackBar(BuildContext context, String text) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 3,
      backgroundColor: kRed.withOpacity(0.7),
      content: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      action: SnackBarAction(
        label: 'OK',
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: Colors.black54,
      ),
    ),
  );
}
