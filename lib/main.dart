import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/FAQ-page.dart';
import '../screens/guidelines-page.dart';
import '../screens/login-page.dart';
import '../screens/mentor-profile.dart';
import '../screens/schedule-complete.dart';
import '../screens/signup-page.dart';

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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        MentorProfile.route: (context) => MentorProfile(),
        SignUp.route: (context) => SignUp(),
        ScheduleComplete.route: (context) => ScheduleComplete(),
        FAQPage.route: (context) => FAQPage(),
        GuidelinesPage.route: (context) => GuidelinesPage(),
      },
      theme: ThemeData(fontFamily: 'Montserrat'),
      initialRoute: user ? MentorProfile.route : LoginPage.route,
    );
  }
}
