import 'package:flutter/material.dart';
import 'package:tsep/screens/login-page.dart';

void main() => runApp(TSEP());

class TSEP extends StatelessWidget {
  const TSEP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrant'),
      home: LoginPage(),
    );
  }
}
