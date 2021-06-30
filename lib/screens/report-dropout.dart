import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tsep/local-data/constants.dart';
import 'package:tsep/logic/cached-data.dart';
import 'package:tsep/logic/firestore.dart';

class ReportDropout extends StatefulWidget {
  ProfileHandler firestore;
  ReportDropout({required this.firestore});
  static String route = "ReportDropout";
  @override
  _ReportDropoutState createState() => _ReportDropoutState();
}

final firestore = ProfileHandler();

class _ReportDropoutState extends State<ReportDropout> {
  @override
  void initState() {
    super.initState();
    firestore.DeclareCompletionData(displayMentees);
  }

  List<Widget> displayMentees() {
    List<Widget> result = [];
    menteesList.forEach((Mentee mentee) {
      result.add(MenteeInformationCard(mentee: mentee));
    });
    setState(() {});
    return result;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TitleBar(),
              DropoutWarningWrapper(),
              ...displayMentees(),
            ],
          ),
        ),
      ),
    );
  }
}

class MenteeInformationCard extends StatelessWidget {
  Mentee mentee;
  MenteeInformationCard({required this.mentee});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kRed.withOpacity(0.15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: size.width * 0.25, maxHeight: size.height * 0.16),
              child: Image.asset(
                mentee.gender == 'male'
                    ? 'assets/vectors/Mentee(M)sad.png'
                    : 'assets/vectors/Mentee(F)sad.png',
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  mentee.fullName,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: kRed.withOpacity(0.9)),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              height: size.height * 0.17,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Confirm Action",
                                      style: TextStyle(
                                          color: kRed.withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 13, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: kRed.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "This action cannot be undone!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17,
                                          color: kRed.withOpacity(0.9),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ConfirmationWrapper(
                                      mentee: mentee,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "REPORT DROPOUT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: kRed.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: kRed.withOpacity(0.9),
                          blurRadius: 15,
                        )
                      ],
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

class DropoutWarningWrapper extends StatelessWidget {
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
            'Recommended Action',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: kGreen.withOpacity(0.9)),
          ),
          SizedBox(height: 5),
          Text(
            "Please be mindful of the action you are about to take, reverting a dropped mentee is not possible, please consider contacting KEF staff at least once, before performing this action.",
            style: TextStyle(color: kGreen, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: kGreen,
                size: 20,
              ),
              Text(
                " +91 9876543210",
                style: TextStyle(color: kGreen, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.email,
                color: kGreen,
                size: 20,
              ),
              Text(
                " support@kotakeducationfoundation.com",
                style: TextStyle(color: kGreen, fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
              "Report Dropout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.5),
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmationWrapper extends StatelessWidget {
  Mentee mentee;
  ConfirmationWrapper({required this.mentee});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(context),
                child: Container(
                  child: Center(
                    child: Text(
                      "CANCLE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  height: size.height * 0.042,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: kLightBlue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: kLightBlue,
                        blurRadius: 10,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(context);
                  firestore.DropMentee(mentee);
                  showSnackBar(
                      context, 'The declaration was filed successfully!');
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "CONFIRM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  height: size.height * 0.042,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: kRed.withOpacity(0.7),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: kRed.withOpacity(0.7),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
