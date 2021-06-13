import 'package:flutter/material.dart';
import 'package:tsep/screens/FAQ-page.dart';
import 'package:tsep/screens/guidelines-page.dart';
import 'package:tsep/screens/info-page.dart';
import 'package:tsep/screens/login-page.dart';
import 'package:tsep/screens/mentee-details-page.dart';
import 'package:tsep/screens/mentees-list-page.dart';
import 'package:tsep/screens/mentor-profile.dart';
import 'package:tsep/screens/schedule-new-lecture.dart';
import 'package:tsep/screens/schedule-page.dart';
import 'package:tsep/screens/test-screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TSEP());
}

class TSEP extends StatelessWidget {
  const TSEP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: LoginPage(),
    );
  }
}
