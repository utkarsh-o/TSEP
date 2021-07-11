import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../screens/mentee-info-page.dart';
import '../screens/mentee-profile.dart';
import '../screens/mentee-schedule-page.dart';
import '../local-data/constants.dart';
import '../logic/ad_helper.dart';

class MenteeCustomBottomNavBar extends StatefulWidget {
  int active = 0;
  MenteeCustomBottomNavBar({required this.active});
  @override
  _MenteeCustomBottomNavBarState createState() =>
      _MenteeCustomBottomNavBarState();
}

class _MenteeCustomBottomNavBarState extends State<MenteeCustomBottomNavBar> {
  late BannerAd _ad;
  bool isLoaded = false;
  String email = '', password = '';
  List<Widget> pages = [
    MenteeProfile(),
    MenteeSchedulePage(),
    MenteeInfoPage(),
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
        print('Ad failed to load with error -> $error');
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: NavbarIconSmall(
                  icon: 'assets/icons/home-bnb.svg',
                  index: 0,
                  active: widget.active,
                  onPressed: setactv),
            ),
            Expanded(
              child: NavbarIconSmall(
                  icon: 'assets/icons/schedule-bnb.svg',
                  index: 1,
                  active: widget.active,
                  onPressed: setactv),
            ),
            Expanded(
              child: NavbarIconSmall(
                  icon: 'assets/icons/info-bnb.svg',
                  index: 2,
                  active: widget.active,
                  onPressed: setactv),
            )
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
    // double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: kRed.withOpacity(0),
      highlightColor: kRed.withOpacity(0),
      onTap: () => onPressed(index),
      child: Container(
        // width: screenWidth / 5,
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
