import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/CustomNavigationBar.dart';
import '../local-data/constants.dart';
import '../logic/cached-data.dart';
import '../logic/data-processing.dart';
import '../screens/mentee-details-page.dart';

bool assigned = true;

class MenteesPage extends StatefulWidget {
  @override
  _MenteesPageState createState() => _MenteesPageState();
}

class _MenteesPageState extends State<MenteesPage> {
  void initState() {
    super.initState();
    assigned = false;
    parseMenteeList();
    getDataStream();
  }

  List<Widget> menteeCards = [];
  parseMenteeList() {
    for (var mentee in menteesList) {
      menteeCards.add(
        MenteeCard(
          name: mentee.fullName,
          lesson: mentee.latestLecture,
          level: mentee.initialLevel,
          uid: mentee.uid,
          phone: mentee.phoneNumber,
        ),
      );
    }
    assigned = menteeCards.length > 0 ? true : false;
  }

  getDataStream() async {
    await for (var snapshot
        in firestore.collection('MentorData/$mentorUID/Mentees').snapshots()) {
      setState(() {
        super.setState(() {});
      });
    }
  }

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
                !assigned
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            vertical: size.height * 0.2,
                            horizontal: size.width * 0.1),
                        child: Column(
                          children: [
                            Text(
                              "Please check back later, you will be assigned mentee/s shortly!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size.height * 0.05),
                            SpinKitSquareCircle(
                              color: Color(0xff003670).withOpacity(0.5),
                              size: 70,
                            ),
                          ],
                        ),
                      )
                    : Column(children: menteeCards)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(active: 2),
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
              "Mentees",
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

class MenteeCard extends StatelessWidget {
  final String name, level, uid;
  final int lesson, phone;
  MenteeCard(
      {required this.name,
      required this.level,
      required this.lesson,
      required this.uid,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int screenWidthInt = size.width.round();
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
        width: size.width * 0.9,
        height: size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MenteeDetails(
                        menteeUID: uid,
                      );
                    },
                  ),
                );
              },
              child: Container(
                height: 35,
                width: 40,
                margin: EdgeInsets.only(left: 15),
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
                    parseInitials(name),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: size.width * 0.37),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MenteeDetails(
                          menteeUID: uid,
                        );
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
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
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
              padding: EdgeInsets.symmetric(horizontal: screenWidthInt * 0.01),
              child: Text(
                phone.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _launchCaller(phone);
              },
              icon: SvgPicture.asset(
                "assets/icons/phone-call.svg",
                height: size.width * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_launchCaller(num number) async {
  final url = "tel:${number.toString()}";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
