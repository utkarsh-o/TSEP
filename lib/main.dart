import 'package:flutter/material.dart';
import 'package:tsep/screens/FAQ-page.dart';
import 'package:tsep/screens/guidelines-page.dart';
import 'package:tsep/screens/info-page.dart';
import 'package:tsep/screens/login-page.dart';
import 'package:tsep/screens/mentee-details-page.dart';
import 'package:tsep/screens/mentees-list-page.dart';
import 'package:tsep/screens/mentor-profile-template.dart';
import 'package:tsep/screens/mentor-profile.dart';
import 'package:tsep/screens/schedule-complete.dart';
import 'package:tsep/screens/schedule-new-lecture.dart';
import 'package:tsep/screens/schedule-page.dart';
import 'package:tsep/screens/signup-page.dart';
import 'package:tsep/screens/test-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  var user = auth.currentUser;
  if (user != null) {
    runApp(TSEP(
      user: true,
    ));
  } else {
    runApp(TSEP(
      user: false,
    ));
  }
}

class TSEP extends StatelessWidget {
  final bool user;
  TSEP({required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginPage(),
        MentorProfile.route: (context) => MentorProfile(),
        SignUp.route: (context) => SignUp(),
        ScheduleComplete.route: (context) => ScheduleComplete(),
      },
      theme: ThemeData(fontFamily: 'Montserrat'),
      // home: user ? MentorProfile() : LoginPage(),
      initialRoute: user ? MentorProfile.route : LoginPage.route,
    );
  }
}
