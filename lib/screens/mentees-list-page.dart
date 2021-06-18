import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/local-data/constants.dart';
import 'package:tsep/logic/data-processing.dart';
import '../components/CustomNavigationBar.dart';
import '../logic/cached-data.dart';
import '../screens/mentee-details-page.dart';

bool Assigned = true;

class MenteesPage extends StatefulWidget {
  @override
  _MenteesPageState createState() => _MenteesPageState();
}

class _MenteesPageState extends State<MenteesPage> {
  void initState() {
    super.initState();
    Assigned = false;
    parseMenteeList();
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
        ),
      );
    }
    Assigned = menteeCards.length > 0 ? true : false;
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
                !Assigned
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
                            SpinKitFadingCube(
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
  final String name, level, uid;
  final int lesson;
  MenteeCard(
      {required this.name,
      required this.level,
      required this.lesson,
      required this.uid});

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
                        MenteeUID: uid,
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
                          MenteeUID: uid,
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
                        fontSize: 13,
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
                "LESSON $lesson",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kBlue,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
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
