import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/screens/admin-home-page.dart';

import '../components/loading.dart';
import '../local-data/constants.dart';
import '../logic/authentication.dart';
import 'mentee-profile.dart';
import 'mentee-signup-page.dart';
import 'mentor-profile.dart';
import 'mentor-signup-page.dart';

class LoginPage extends StatefulWidget {
  static String route = "LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
GlobalKey<FormState> _emailLoginKey = GlobalKey<FormState>();
GlobalKey<FormState> _passwordLoginKey = GlobalKey<FormState>();
// String activeUser = 'Mentor';

enum UserType { Mentor, Mentee, Admin }

emailValidator(String? val) {
  String value = val ?? 'test';
  if (value.isEmpty || value == 'test') {
    return 'Please input email';
  } else if (RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return null;
  } else {
    return 'Invalid email-address';
  }
}

passwordValidator(String? val) {
  String value = val ?? 'test';
  if (value.isEmpty || value == 'test') {
    return 'Please input password';
  } else if (value.length < 6) {
    return 'Password needs to be at least 6 characters long';
  } else
    return null;
}

final auth = Authentication();

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  void loginCallback() async {
    try {
      setState(() {
        loading = true;
      });
      UserType? userType;
      await FirebaseFirestore.instance
          .collection('MentorData')
          .where('email', isEqualTo: emailController.text)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) userType = UserType.Mentor;
      });

      await FirebaseFirestore.instance
          .collection('MenteeInfo')
          .where('email', isEqualTo: emailController.text)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) userType = UserType.Mentee;
      });

      await FirebaseFirestore.instance
          .collection('AdminData')
          .where('email', isEqualTo: emailController.text)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) userType = UserType.Admin;
      });
      if (userType != null) {
        final newUser =
            await auth.loginUser(emailController.text, passwordController.text);
        if (newUser != null) {
          if (userType == UserType.Mentor)
            Navigator.pushReplacementNamed(context, MentorProfile.route);
          else if (userType == UserType.Mentee)
            Navigator.pushReplacementNamed(context, MenteeProfile.route);
          else {
            Navigator.pushReplacementNamed(context, AdminHomePage.route);
          }
        }
      } else {
        showSnackBar(
            context, 'User having the provided email address does not exist');
        setState(() {
          loading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      setState(() {
        loading = false;
      });
    }
  }

  void displayCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MainLogo(),
                      SignupWrapper(),
                      // AdminMentorMenteeWrapper(
                      //   loginCallback: displayCallback,
                      // ),
                      SizedBox(height: size.height * 0.025),
                      EmailPasswordInputForm(),
                      ForgotPasswordWrapper(),
                      LoginWrapper(
                        loginCallback: loginCallback,
                        displayCallback: displayCallback,
                      ),
                      FooterText(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class FooterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Made in India with "),
        Icon(Icons.favorite, color: Colors.grey, size: 15),
      ],
    );
  }
}

class LoginWrapper extends StatelessWidget {
  final VoidCallback loginCallback, displayCallback;
  LoginWrapper({required this.loginCallback, required this.displayCallback});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
          // minimumSize: Size(size.width * 0.6, size.height * 0.06),
          primary: kRed.withOpacity(0.65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (!_emailLoginKey.currentState!.validate()) {
            return;
          }
          if (!_passwordLoginKey.currentState!.validate()) {
            return;
          }
          loginCallback();
        },
        child: Text(
          'Login',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ForgotPasswordWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Forgot Password ? /',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Open Sans',
            color: Color(0xffAFAFAD),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (emailValidator(emailController.text) == null) {
              showSnackBar(context, 'Reset email has been sent to your email');
              await auth.resetPassword(emailController.text);
            } else
              showSnackBar(context, 'Please enter valid email address.');
          },
          child: Text(
            "Reset",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Open Sans',
              color: Color(0xff6D6D6D),
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        )
      ],
    );
  }
}

// class AdminMentorMenteeWrapper extends StatefulWidget {
//   VoidCallback loginCallback;
//   AdminMentorMenteeWrapper({required this.loginCallback});
//   @override
//   _AdminMentorMenteeWrapperState createState() =>
//       _AdminMentorMenteeWrapperState();
// }

// class _AdminMentorMenteeWrapperState extends State<AdminMentorMenteeWrapper> {
//   void onTap(String who) {
//     setState(() {
//       activeUser = who;
//     });
//     widget.loginCallback();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         MentorMenteeButton(
//           icon: "assets/icons/admin.svg",
//           who: 'Admin',
//           active: activeUser,
//           ontap: onTap,
//         ),
//         MentorMenteeButton(
//           icon: "assets/icons/mentee.svg",
//           who: 'Mentee',
//           active: activeUser,
//           ontap: onTap,
//         ),
//         MentorMenteeButton(
//           icon: "assets/icons/mentor.svg",
//           who: 'Mentor',
//           active: activeUser,
//           ontap: onTap,
//         ),
//       ],
//     );
//   }
// }

class MentorMenteeButton extends StatelessWidget {
  final String icon, who, active;
  final Function ontap;

  MentorMenteeButton(
      {required this.icon,
      required this.who,
      required this.active,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(5),
      decoration: active == who
          ? BoxDecoration(
              color: kBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8))
          : null,
      child: InkWell(
        onTap: () => ontap(who),
        child: SvgPicture.asset(
          icon,
          height: size.height * 0.05,
        ),
      ),
    );
  }
}

class SignupWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lets get started\nLog in.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                height: 180,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sign-Up",
                                        style: TextStyle(
                                          color: kBlue.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        // margin: EdgeInsets.only(top: 10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: kRed.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Carefully select user type",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                            color: kRed.withOpacity(0.7),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      MenteeMentorSelectorWrapper(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff6D6D6D),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SvgPicture.asset(
            "assets/tsep-logo1.svg",
            height: MediaQuery.of(context).size.width * 0.21,
          ),
        ],
      ),
    );
  }
}

class MenteeMentorSelectorWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MenteeSignUp()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    children: [
                      // SvgPicture.asset(
                      //   "assets/icons/mentee.svg",
                      //   height: size.height * 0.05,
                      //   color: Colors.white,
                      // ),
                      Text(
                        "MENTEE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "( student )",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            // fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: kLightBlue,
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
              SizedBox(width: 24),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MentorSignUp()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    children: [
                      // SvgPicture.asset(
                      //   "assets/icons/mentor.svg",
                      //   height: size.height * 0.05,
                      //   color: Colors.white,
                      // ),
                      Text(
                        "MENTOR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "( teacher )",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            // fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: kLightBlue,
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
            ],
          ),
        ],
      ),
    );
  }
}

class MainLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
      child: SvgPicture.asset(
        "assets/Kotak_Mahindra_Bank_logo.svg",
        height: MediaQuery.of(context).size.height * 0.25,
      ),
    );
  }
}

class EmailPasswordInputForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AutofillGroup(
      child: Column(
        children: [
          Form(
            key: _emailLoginKey,
            child: TextFormField(
              controller: emailController,
              validator: (String? val) => emailValidator(val),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[ ]')),
              ],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: kBlue.withOpacity(0.7),
                // border: OutlineInputBorder(),
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Color(0x00003670), width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Color(0x00003670), width: 0),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.0125),
          Form(
            key: _passwordLoginKey,
            child: TextFormField(
              controller: passwordController,
              autofillHints: [AutofillHints.password],
              validator: (String? val) => passwordValidator(val),
              obscureText: true,
              style: TextStyle(
                color: Color(0xffAFAFAD),
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF5F5F5),
                // border: OutlineInputBorder(),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Color(0xffAFAFAD),
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
            ),
          )
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
