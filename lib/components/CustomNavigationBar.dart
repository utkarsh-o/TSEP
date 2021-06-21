import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../local-data/constants.dart';
import '../screens/info-page.dart';
import '../screens/mentees-list-page.dart';
import '../screens/mentor-profile.dart';
import '../screens/schedule-new-lecture.dart';
import '../screens/schedule-page.dart';
import '../screens/test-screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  int active = 0;
  CustomBottomNavBar({required this.active});
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  List<Widget> pages = [
    MentorProfile(),
    SchedulePage(),
    MenteesPage(),
    InfoPage()
  ];

  void setactv(int idx) {
    if (widget.active != idx) {
      setState(
        () {
          widget.active = idx;
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => pages[idx],
              transitionDuration: Duration(seconds: 0),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        NavbarIconSmall(
            icon: 'assets/icons/home-bnb.svg',
            index: 0,
            active: widget.active,
            onPressed: setactv),
        NavbarIconSmall(
            icon: 'assets/icons/schedule-bnb.svg',
            index: 1,
            active: widget.active,
            onPressed: setactv),
        InkWell(
          splashColor: kRed.withOpacity(0),
          highlightColor: kRed.withOpacity(0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ScheduleNew();
                },
              ),
            );
          },
          child: Container(
            width: screenWidth / 5,
            margin: EdgeInsets.only(bottom: 30),
            child: SvgPicture.asset(
              "assets/icons/button-add.svg",
              height: screenHeight * 0.09,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: kRed.withOpacity(1),
                  blurRadius: 20,
                  spreadRadius: -15,
                ),
              ],
            ),
          ),
        ),
        NavbarIconSmall(
            icon: 'assets/icons/menteelist-bnb.svg',
            index: 2,
            active: widget.active,
            onPressed: setactv),
        NavbarIconSmall(
            icon: 'assets/icons/info-bnb.svg',
            index: 3,
            active: widget.active,
            onPressed: setactv),
      ],
    );
  }
}

class NavbarIconSmall extends StatelessWidget {
  final Function onPressed;
  final String icon;
  final int index, active;
  NavbarIconSmall(
      {required this.icon,
      required this.index,
      required this.onPressed,
      required this.active});
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: kRed.withOpacity(0),
      highlightColor: kRed.withOpacity(0),
      onTap: () => onPressed(index),
      child: Container(
        width: screenWidth / 5,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: kRed.withOpacity(0.5),
              width: 2.0,
            ),
          ),
          boxShadow: active == index
              ? [
                  BoxShadow(
                    color: kRed.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: -20,
                  )
                ]
              : null,
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
