import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../local-data/constants.dart';
import '../logic/ad_helper.dart';
import '../screens/mentor-info-page.dart';
import '../screens/mentees-list-page.dart';
import '../screens/mentor-profile.dart';
import '../screens/schedule-new-lecture.dart';
import '../screens/mentor-schedule-page.dart';

class MentorCustomBottomNavBar extends StatefulWidget {
  int active = 0;
  MentorCustomBottomNavBar({required this.active});
  @override
  _MentorCustomBottomNavBarState createState() =>
      _MentorCustomBottomNavBarState();
}

class _MentorCustomBottomNavBarState extends State<MentorCustomBottomNavBar> {
  late BannerAd _ad;
  bool isLoaded = false;
  String email = '', password = '';
  List<Widget> pages = [
    MentorProfile(),
    MentorSchedulePage(),
    MenteesPage(),
    MentorInfoPage()
  ];
  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(
          () {
            isLoaded = true;
          },
        );
      }, onAdFailedToLoad: (_, error) {
        showSnackBar(context, 'ad error -> $error');
        // print('Ad failed to load with error -> $error');
      }),
    );
    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  void setactv(int idx) {
    if (widget.active != idx) {
      setState(
        () {
          widget.active = idx;
          Navigator.pushReplacement(
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
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
        ),
        Container(
          child: AdWidget(
            ad: _ad,
          ),
          width: _ad.size.width.toDouble(),
          height: 50,
          alignment: Alignment.center,
        ),
        // isLoaded
        //     ? Container(
        //         child: AdWidget(
        //           ad: _ad,
        //         ),
        //         width: _ad.size.width.toDouble(),
        //         height: 50,
        //         alignment: Alignment.center,
        //       )
        //     : CircularProgressIndicator(),
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
