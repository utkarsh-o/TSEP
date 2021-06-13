import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitSquareCircle(
          color: Color(0xffD92136).withOpacity(0.7),
          size: 50,
        ),
      ),
    );
  }
}
