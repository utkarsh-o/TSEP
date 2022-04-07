import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/mentor-customNavigationBar.dart';
import '../local-data/constants.dart';
import '../logic/mentor-cached-data.dart';
import '../logic/mentor-data-processing.dart';
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
          level: mentee.initialLevel,
          uid: mentee.uid,
          phone: mentee.phoneNumber,
          whatsappNumber: mentee.whatsappNumber,
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
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleBar(),
                  !assigned
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              // vertical: size.height * 0.2,
                              // horizontal: size.width * 0.1),
                              vertical: 120,
                              horizontal: 35),
                          child: Column(
                            children: [
                              Text(
                                "Please check back later, you will be assigned mentee(s) shortly!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 35),
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
      ),
      bottomNavigationBar: MentorCustomBottomNavBar(active: 2),
    );
  }
}

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 64, vertical: 25),
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
  final int phone, whatsappNumber;
  MenteeCard(
      {required this.name,
      required this.level,
      required this.uid,
      required this.phone,
      required this.whatsappNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
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
        width: MediaQuery.of(context).size.width * 0.9,
        height: 80,
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
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      level.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IntrinsicHeight(
                          child: Icon(
                            Icons.message_rounded,
                            color: kGreen,
                            size: 12,
                          ),
                        ),
                        SizedBox(width: 6),
                        SelectableText(
                          whatsappNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kGreen,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
              child: SelectableText(
                phone.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                  fontSize: 12,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _launchCaller(phone);
              },
              icon: SvgPicture.asset(
                "assets/icons/phone-call.svg",
                // height: size.width * 0.06,
                height: 20,
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
