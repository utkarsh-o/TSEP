import 'package:flutter/material.dart';
import 'package:tsep/screens/FAQ-page.dart';
import 'package:tsep/screens/guidelines-page.dart';
import 'package:tsep/screens/info-page.dart';
import 'package:tsep/screens/login-page.dart';
import 'package:tsep/screens/mentee-details-page.dart';
import 'package:tsep/screens/mentees-list-page.dart';
import 'package:tsep/screens/mentor-profile.dart';
import 'package:tsep/screens/schedule-page.dart';
import 'package:tsep/screens/test-screen.dart';

void main() => runApp(TSEP());

class TSEP extends StatelessWidget {
  const TSEP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrant'),
      home: MentorProfile(),
    );
  }
}
