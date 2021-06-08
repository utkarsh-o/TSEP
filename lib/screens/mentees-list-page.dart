import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/components/CustomNavigationBar.dart';
import 'package:tsep/screens/mentee-details-page.dart';

class MenteesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleBar(),
                SizedBox(height: size.height * 0.05),
                MenteeCard(name: "Bat Man", level: "Intermediate", lesson: 13),
                MenteeCard(name: "Iron Man", level: "Novice", lesson: 6),
                MenteeCard(name: "Spider Man", level: "Beginner", lesson: 2),
                MenteeCard(name: "Ant Man", level: "Intermediate", lesson: 11),
                MenteeCard(name: "Ant Man", level: "Intermediate", lesson: 11),
                MenteeCard(name: "Ant Man", level: "Intermediate", lesson: 11),
                MenteeCard(name: "Ant Man", level: "Intermediate", lesson: 11),
                MenteeCard(name: "Ant Man", level: "Intermediate", lesson: 11),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        active: 2,
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
            "Mentees",
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

class MenteeCard extends StatelessWidget {
  final String name, level;
  final int lesson;
  const MenteeCard(
      {required this.name, required this.level, required this.lesson});
  String getInitials(name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = 2;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int screenwidth = screenWidth.round();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
        width: screenWidth * 0.85,
        height: screenHeight * 0.1,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MenteeDetails();
                    },
                  ),
                );
              },
              child: Container(
                height: 35,
                width: 40,
                margin: EdgeInsets.only(left: 20),
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
                    getInitials(name),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: screenWidth * 0.32),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MenteeDetails();
                      },
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.003,
                    ),
                    Text(
                      level.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.01),
              child: Text(
                "LESSON $lesson",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff003670),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/phone-call.svg",
                height: screenWidth * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
