import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/components/mentee-customNavigationBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../local-data/constants.dart';
import '../logic/mentor-firestore.dart';
import '../screens/FAQ-page.dart';
import '../screens/guidelines-page.dart';

class MenteeInfoPage extends StatelessWidget {
  const MenteeInfoPage({Key? key}) : super(key: key);

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
          // Container(
          //   width: double.infinity,
          //   margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          //   padding: EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(7),
          //     color: kRed.withOpacity(0.15),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Watch / Listen:',
          //         style: TextStyle(
          //             fontSize: 15,
          //             color: kRed.withOpacity(0.9),
          //             fontWeight: FontWeight.bold),
          //       ),
          //       getLinks(getLessonByNumber(index).videoLinks),
          //     ],
          //   ),
          // ),
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
              getLessonList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MenteeCustomBottomNavBar(
        active: 2,
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
              "Lessons",
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
  Widget getLinks(List<String>? videoLinks, List<String>? homeworkLinks) {
    if (videoLinks == null) return Text('');
    int x = 1;
    List<Widget> result = [];
    for (var link in videoLinks) {
      result.add(
        InkWell(
          onTap: () => launch(link),
          child: Container(
            margin: EdgeInsets.fromLTRB(3, 10, 3, 0),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: kRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3)),
            child: Text(
              'LINK $x',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12, color: kRed),
            ),
          ),
        ),
      );
      x++;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: result),
        Visibility(
          visible: homeworkLinks != null,
          child: InkWell(
            onTap: () => launch(homeworkLinks![0]),
            child: Container(
              margin: EdgeInsets.fromLTRB(3, 10, 3, 0),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: kBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3)),
              child: Text(
                'HOMEWORK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12, color: kBlue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
        // height: size.height * 0.1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: size.width * 0.06,
                      right: size.width * 0.04),
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
                  width: size.width * 0.38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lesson $index",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "${lesson.title}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: size.width * 0.03, right: size.width * 0.03),
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
            Visibility(
              visible: index != 1,
              child: Container(
                // width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: kRed.withOpacity(0.15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Watch / Listen:',
                      style: TextStyle(
                          fontSize: 15,
                          color: kRed.withOpacity(0.9),
                          fontWeight: FontWeight.bold),
                    ),
                    getLinks(getLessonByNumber(index).videoLinks,
                        lessonData[index - 1].homeworkLinks),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

_openPDF(String url, BuildContext context) async {
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
