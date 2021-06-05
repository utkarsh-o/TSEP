import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenteesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleBar(),
                SizedBox(height: screenHeight * 0.05),
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        NavbarIconSmall(icon: 'assets/icons/home-bnb.svg', index: 0),
        NavbarIconSmall(icon: 'assets/icons/schedule-bnb.svg', index: 1),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: screenWidth / 5,
            margin: EdgeInsets.only(bottom: 30),
            child: SvgPicture.asset(
              "assets/icons/button-add.svg",
              height: screenHeight * 0.09,
            ),
          ),
        ),
        NavbarIconSmall(icon: 'assets/icons/menteelist-bnb.svg', index: 2),
        NavbarIconSmall(icon: 'assets/icons/notifications-bnb.svg', index: 3),
      ],
    );
  }
}

class NavbarIconSmall extends StatelessWidget {
  final String icon;
  final int index;
  NavbarIconSmall({required this.icon, required this.index});
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: screenWidth / 5,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xffD92136).withOpacity(0.5),
              width: 2.0,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: SvgPicture.asset(
          icon,
          height: screenHeight * 0.03,
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
        SvgPicture.asset(
          "assets/icons/settings-tb.svg",
          height: screenWidth * 0.06,
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
            Container(
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
            Container(
              constraints: BoxConstraints(minWidth: 120),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
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
                    height: 3,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
