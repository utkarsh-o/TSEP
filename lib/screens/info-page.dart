import 'package:flutter/material.dart';
import 'package:tsep/components/CustomNavigationBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/local-data/lessons.dart';
import 'package:tsep/screens/FAQ-page.dart';
import 'package:tsep/screens/guidelines-page.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getLessonList() {
      List<Widget> lessonList = [];
      for (var index = 0; index < lessons.length; index++) {
        lessonList.add(new LessonCard(
            lesson: index + 1,
            title: lessons[index].title,
            duration: lessons[index].duration));
      }
      return new Column(children: lessonList);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBar(),
              FAQGdlineCards(),
              BreakLine(),
              RsrsText(),
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

class RsrsText extends StatelessWidget {
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Text(
            "Information",
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
          onTap: () {},
          child: SvgPicture.asset(
            "assets/icons/settings-tb.svg",
            height: screenWidth * 0.06,
          ),
        )
      ],
    );
  }
}

class FAQGdlineCards extends StatelessWidget {
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
              Navigator.push(
                (context),
                MaterialPageRoute(
                  builder: (context) {
                    return FAQPage();
                  },
                ),
              );
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
          ),
          InkWell(
            splashColor: Color(0xffD92136).withOpacity(0),
            highlightColor: Color(0xffD92136).withOpacity(0),
            onTap: () {
              Navigator.push(
                (context),
                MaterialPageRoute(
                  builder: (context) {
                    return GuidelinesPage();
                  },
                ),
              );
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
            color: Color(0xff003670).withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final int lesson;
  final String title, duration;
  LessonCard(
      {required this.lesson, required this.title, required this.duration});
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
        height: size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: size.width * 0.06),
              height: 35,
              width: 40,
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
              constraints: BoxConstraints(minWidth: 150),
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
                    "$title",
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
                "$duration",
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
