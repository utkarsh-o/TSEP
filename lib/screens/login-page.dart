import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/screens/mentor-profile.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.12,
              // vertical: size.height * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                mainLogo(),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                SignupWrapper(),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                MntrMenteeWrapper(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                LoginPageInputForm(name: 'Username'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
                LoginPageInputForm(name: 'Password'),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                frgtPassWrapper(),
                LoginWrapper(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Made in India with "),
                    Icon(
                      Icons.favorite,
                      color: Colors.grey,
                      size: 15,
                    ),
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

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(size.width * 0.6, size.height * 0.06),
              primary: Color(0xffD92136).withOpacity(0.65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MentorProfile();
                  },
                ),
              );
            },
            child: Text('Login'),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/google-login.svg",
              height: 40,
            ),
          )
        ],
      ),
    );
  }
}

class frgtPassWrapper extends StatelessWidget {
  const frgtPassWrapper({
    Key? key,
  }) : super(key: key);

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
          onPressed: () {},
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

class MntrMenteeWrapper extends StatelessWidget {
  const MntrMenteeWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MentorMenteeButton(icon: "assets/icons/mentee.svg"),
        MentorMenteeButton(icon: "assets/icons/mentor.svg"),
      ],
    );
  }
}

class SignupWrapper extends StatelessWidget {
  const SignupWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.025),
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
                    onPressed: () {},
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
            "assets/tsep-logo.svg",
            height: MediaQuery.of(context).size.height * 0.11,
          ),
        ],
      ),
    );
  }
}

class mainLogo extends StatelessWidget {
  const mainLogo({
    Key? key,
  }) : super(key: key);

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

class LoginPageInputForm extends StatelessWidget {
  final String name;
  LoginPageInputForm({required this.name});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: name == 'Username' ? TextInputType.emailAddress : null,
      obscureText: name == 'Username' ? false : true,
      style: TextStyle(
        color: name == 'Username' ? Colors.white : Color(0xffAFAFAD),
        fontWeight: FontWeight.w600,
      ),
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

class MentorMenteeButton extends StatelessWidget {
  const MentorMenteeButton({Key? key, required this.icon}) : super(key: key);
  final String icon;
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
