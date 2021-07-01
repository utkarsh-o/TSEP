import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../local-data/constants.dart';
import '../logic/mentor-cached-data.dart';
import '../logic/mentor-firestore.dart';

class DeclareCompletion extends StatefulWidget {
  ProfileHandler firestore;
  DeclareCompletion({required this.firestore});
  static String route = "DeclareCompletion";
  @override
  _DeclareCompletionState createState() => _DeclareCompletionState();
}

class _DeclareCompletionState extends State<DeclareCompletion> {
  @override
  void initState() {
    super.initState();
    final firebase = ProfileHandler();
    firebase.DeclareCompletionData(displayMentees);
  }

  List<Widget> displayMentees() {
    List<Widget> result = [];
    menteesList.forEach((Mentee mentee) {
      result.add(MenteeInformationCard(
        mentee: mentee,
        firestore: widget.firestore,
      ));
    });
    setState(() {});
    return result;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleBar(),
            CompletionCriterionWrapper(),
            ...displayMentees()
          ],
        ),
      ),
    );
  }
}

class MenteeInformationCard extends StatelessWidget {
  ProfileHandler firestore;
  Mentee mentee;
  MenteeInformationCard({required this.mentee, required this.firestore});
  bool checkCompleted() {
    if (mentee.totalEngagementTime >= Duration(hours: 15) ||
        mentee.totalEngagementLectures >= 30)
      return true;
    else if (mentee.totalEngagementTime >= Duration(hours: 11) &&
        mentee.totalEngagementLectures >= 15)
      return true;
    else if (mentee.totalEngagementLectures >= 22 &&
        mentee.totalEngagementTime >= Duration(hours: 7)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool completed = checkCompleted();
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kLightBlue.withOpacity(0.15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: size.width * 0.25, maxHeight: size.height * 0.16),
              child: Image.asset(
                mentee.gender == 'male'
                    ? 'assets/vectors/Mentee(M)happy.png'
                    : 'assets/vectors/Mentee(F)happy.png',
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  mentee.fullName,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: kLightBlue.withOpacity(0.9)),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenteeTotalInformationCards(
                        text: '${mentee.totalEngagementLectures} lessons',
                      ),
                      MenteeTotalInformationCards(
                        text:
                            "${(mentee.totalEngagementTime.inMinutes / 60).floor()} hr ${mentee.totalEngagementTime.inMinutes % 60} min",
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (!completed) {
                      showSnackBar(context,
                          'Minimum requirements not met for the selected mentee');
                    } else {
                      firestore.DeclareCompletion(mentee);
                      showSnackBar(
                          context, 'The declaration was filed successfully!');
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "DECLARE COMPLETION",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: !completed ? kLightBlue : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    decoration: completed
                        ? BoxDecoration(
                            color: kLightBlue.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: kLightBlue.withOpacity(0.9),
                                blurRadius: 15,
                              )
                            ],
                          )
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: kLightBlue.withOpacity(0.7), width: 5),
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MenteeTotalInformationCards extends StatelessWidget {
  String text;
  MenteeTotalInformationCards({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: kRed.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          // textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class CompletionCriterionWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kGreen.withOpacity(0.15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completion Criterion:',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: kGreen.withOpacity(0.9)),
          ),
          SizedBox(height: 5),
          Text(
            "1. More than 11 hours devoted and more than 15 lessons taken",
            style: TextStyle(color: kGreen, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "2. More than 22 lessons taken devoted and more than 7 hours devoted",
            style: TextStyle(color: kGreen, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "3. 30 lessons taken",
            style: TextStyle(color: kGreen, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "4. 15 hours devoted",
            style: TextStyle(color: kGreen, fontWeight: FontWeight.bold),
          ),
          TotalInformationWrapper(),
        ],
      ),
    );
  }
}

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                "assets/icons/back-tb.svg",
                height: size.height * 0.07,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.05,
            height: size.height * 0.12,
          ),
          Container(
            child: Text(
              "Declare Completion",
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

class TotalInformationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TotalInformationCards(
            text: "Total Lessons = 30",
          ),
          TotalInformationCards(
            text: "Total Hours = 15",
          ),
        ],
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

class TotalInformationCards extends StatelessWidget {
  String text;
  TotalInformationCards({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Color(0xff34A853).withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          // textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
