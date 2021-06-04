import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Container(
                  // height: 100,
                  child: SvgPicture.asset(
                    "assets/Kotak_Mahindra_Bank_logo.svg",
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lets get started\nLog in.",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                'If you are new /',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffAFAFAD),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff6D6D6D),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/tsep-logo.svg",
                      height: 75,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    mentorMenteeButton(icon: "assets/icons/mentee.svg"),
                    mentorMenteeButton(icon: "assets/icons/mentor.svg"),
                  ],
                ),
                loginPageInputForm(name: 'Username'),
                SizedBox(
                  height: 15,
                ),
                loginPageInputForm(name: 'Password'),
                Row(
                  children: [
                    Container(
                      child: Text(
                        'Forgot Password ? /',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open Sans',
                          color: Color(0xffAFAFAD),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open Sans',
                          color: Color(0xff6D6D6D),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(220, 50),
                        primary: Color(0xffD92136).withOpacity(0.65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('Login'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    // SvgPicture.asset(
                    //   "assets/icons/google-login.svg",
                    //   height: 40,
                    // ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        "assets/icons/google-login.svg",
                        height: 40,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class loginPageInputForm extends StatelessWidget {
  final name;
  final pressFunction;
  const loginPageInputForm({Key? key, this.name, this.pressFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: name == 'Username'
            ? Color(0xff003670).withOpacity(0.7)
            : Color(0xffF5F5F5),
        // border: OutlineInputBorder(),
        hintText: name,
        hintStyle: TextStyle(
          color: name == 'Username' ? Colors.white : Color(0xffAFAFAD),
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          borderSide: BorderSide(color: Color(0x00003670), width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          borderSide: BorderSide(color: Color(0x00003670), width: 0),
        ),
      ),
    );
  }
}

class mentorMenteeButton extends StatelessWidget {
  final icon;
  const mentorMenteeButton({Key? key, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        icon,
      ),
    );
  }
}
