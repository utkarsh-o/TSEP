import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsep/logic/authentication.dart';
import 'package:tsep/logic/mentor-firestore.dart';
import 'package:tsep/screens/login-page.dart';
import 'package:tsep/screens/post-test-screen.dart';
import '../local-data/constants.dart';

class AdminHomePage extends StatefulWidget {
  static const String route = 'AdminPage';

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late FirebaseFirestore firestore;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    void logoutCallback() {
      final auth = Authentication();
      auth.signoutUser();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                      vertical: size.height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Admin Panel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: logoutCallback,
                        child: Container(
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
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('Completion')
                      .orderBy('DateDeclared')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> completionList = [];
                    if (snapshot.hasData) {
                      final completions = snapshot.data!.docs;
                      completions.forEach(
                        (element) async {
                          final menteeUID = element.get('MenteeUID');
                          final mentorUID = element.get('MentorUID');
                          completionList.add(
                            CompletionCard(
                              completion: Completion(
                                menteeInitialLevel:
                                    element.get('MenteeInitialLevel'),
                                menteeID: element.get('MenteeID'),
                                menteeJoiningDate:
                                    element.get('MenteeJoiningDate').toDate(),
                                mentorCategory: element.get('MentorCategory'),
                                mentorID: element.get('MentorID'),
                                preTestScore: element.get('PreTestScore'),
                                menteeGender: element.get('MenteeGender'),
                                mentorGender: element.get('MentorGender'),
                                menteeName: element.get('MenteeName'),
                                menteeUID: menteeUID,
                                mentorName: element.get('MentorName'),
                                mentorUID: mentorUID,
                                engagementTime: Duration(
                                    minutes: element.get('EngagementTime')),
                                lessonCount: element.get('LessonCount'),
                                menteeBatch: element.get('MenteeBatch'),
                                mentorBatch: element.get('MentorBatch'),
                                dateDeclared:
                                    element.get('DateDeclared').toDate(),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Column(
                      children: completionList,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompletionCard extends StatelessWidget {
  Completion completion;
  CompletionCard({required this.completion});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: kGreen.withOpacity(0.45), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kLightBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Image.asset(
                    completion.menteeGender == 'male'
                        ? 'assets/vectors/Mentee(M)happy.png'
                        : 'assets/vectors/Mentee(F)happy.png',
                    // height: 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completion.menteeName,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    MenteeProfileDetail(
                        heading: 'Initial Level',
                        value: completion.menteeInitialLevel),
                    MenteeProfileDetail(
                        heading: 'Pre-Test Score',
                        value: '${completion.preTestScore}/30'),
                    MenteeProfileDetail(
                        heading: 'Joining Date',
                        value: DateFormat('dd MMMM yyyy')
                            .format(completion.menteeJoiningDate)),
                    MenteeProfileDetail(
                        heading: 'Time Since Joined',
                        value:
                            getJoiningDuration(completion.menteeJoiningDate)),
                    MenteeProfileDetail(
                        heading: 'Batch', value: completion.menteeBatch),
                    MenteeProfileDetail(
                        heading: 'ID', value: completion.menteeID.toString()),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: kGreen.withOpacity(0.7), blurRadius: 10)
            ], borderRadius: BorderRadius.circular(3), color: kGreen),
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostTestScreen(menteeUID: completion.menteeUID))),
              child: Text(
                'POST TEST',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kRed.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      completion.mentorName,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    MentorProfileDetail(
                        heading: 'Lessons Taken',
                        value: completion.lessonCount.toString()),
                    MentorProfileDetail(
                        heading: 'Engagement',
                        value:
                            '${(completion.engagementTime.inMinutes / 60).toStringAsFixed(0)} hr ${completion.engagementTime.inMinutes % 60} min'),
                    MentorProfileDetail(
                        heading: 'Organization',
                        value: completion.mentorCategory),
                    MentorProfileDetail(
                        heading: 'Batch', value: completion.mentorBatch),
                    MentorProfileDetail(
                        heading: 'ID', value: completion.mentorID.toString()),
                  ],
                ),
                Container(
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Image.asset(
                    completion.mentorGender == 'male'
                        ? 'assets/vectors/Mentor(M).png'
                        : 'assets/vectors/Mentor(F).png',
                    // height: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String getJoiningDuration(DateTime date) {
  Duration duration = DateTime.now().difference(date);
  return '${(duration.inDays / 7).toStringAsFixed(0)} weeks ${(duration.inDays % 7).toStringAsFixed(0)} days';
}

class MenteeProfileDetail extends StatelessWidget {
  String heading, value;
  MenteeProfileDetail({required this.heading, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$heading:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        SizedBox(width: 6),
        Text(
          value.toUpperCase(),
          style: TextStyle(
              fontSize: 12,
              color: kBlue.withOpacity(0.7),
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }
}

class MentorProfileDetail extends StatelessWidget {
  String heading, value;
  MentorProfileDetail({required this.heading, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$heading:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        SizedBox(width: 6),
        Text(
          value.toUpperCase(),
          style: TextStyle(
              fontSize: 12,
              color: kRed.withOpacity(0.7),
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }
}

class MenteeTotalInformationCards extends StatelessWidget {
  String heading;
  double percentage;
  MenteeTotalInformationCards(
      {required this.heading, required this.percentage});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: kRed.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              heading,
              // textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: kRed.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              '${percentage.toStringAsFixed(1)} %',
              // textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
