import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tsep/components/loading.dart';
import 'package:tsep/screens/login-page.dart';
import 'package:tsep/screens/mentor-profile.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

String email = '',
    pass = '',
    uid = '',
    FirstName = '',
    LastName = '',
    Organization = '',
    Batch = '',
    Gender = 'male';
bool loading = false;
int IDNumber = -1;

class _SignUpState extends State<SignUp> {
  void emailcbk(String e) => email = e;
  void passcbk(String p) => pass = p;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  void signUpcbk() async {
    try {
      setState(() {
        loading = true;
      });
      final newUser = (await auth.createUserWithEmailAndPassword(
              email: email, password: pass))
          .user;
      if (newUser != null) {
        uid = newUser.uid;
        print(uid);
        setState(() {
          loading = false;
        });
        firestore.collection('/MentorData').doc(uid).set({
          'BatchName': Batch,
          'FirstName': FirstName,
          'IDNumber': -1,
          'JoiningDate': Timestamp.fromDate(DateTime.now()),
          'LastName': LastName,
          'Organization': Organization,
          'email': email,
          'Gender': Gender,
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      //   print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TitleBar(),
                    AvatarWrapper(),
                    NameWrapper(),
                    OrgBchWrapper(),
                    EmailInputForm(callback: emailcbk),
                    PasswordInputForm(callback: passcbk),
                    LoginWrapper(callback: signUpcbk)
                  ],
                ),
              ),
            ),
          );
  }
}

class AvatarWrapper extends StatefulWidget {
  @override
  _AvatarWrapperState createState() => _AvatarWrapperState();
}

class _AvatarWrapperState extends State<AvatarWrapper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 30, bottom: 10),
          child: Text(
            "Avatar",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.6),
                fontSize: 16),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  Gender = 'female';
                });
              },
              child: Container(
                child: Image.asset(
                  'assets/vectors/Mentor(F).png',
                  width: size.width * 0.3,
                ),
                decoration: Gender == 'female'
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffD92136).withOpacity(0.8),
                            blurRadius: 45,
                          )
                        ],
                      )
                    : null,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  Gender = 'male';
                });
              },
              child: Container(
                child: Image.asset(
                  'assets/vectors/Mentor(M).png',
                  width: size.width * 0.2,
                ),
                decoration: Gender == 'male'
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff003670).withOpacity(0.8),
                            blurRadius: 50,
                            spreadRadius: 10,
                          )
                        ],
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NameWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "First Name",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                width: size.width * 0.45,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffD92136).withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffD92136).withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  onChanged: (val) => FirstName = val,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.037,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Chirag",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.037,
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Last Name",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                margin: EdgeInsets.only(top: 7),
                alignment: Alignment.center,
                width: size.width * 0.45,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffD92136).withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffD92136).withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  onChanged: (val) => LastName = val,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.037,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Gupta",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.037,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OrgBchWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Organization",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                alignment: Alignment.center,
                width: size.width * 0.45,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xff003670).withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff003670).withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  onChanged: (val) => Organization = val,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.037,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.card_travel,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Individual",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.037,
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Batch",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                width: size.width * 0.45,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xff003670).withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff003670).withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  onChanged: (val) => Batch = val,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.037,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.today,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Apr2021",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.037,
                    ),
                  ),
                ),
              )
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
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
              height: screenWidth * 0.07,
            ),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.05,
          height: screenHeight * 0.12,
        ),
        Container(
          child: Text(
            "Sing Up",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class EmailInputForm extends StatelessWidget {
  @override
  final Function callback;
  EmailInputForm({required this.callback});
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 25),
      width: size.width * 0.7,
      child: TextFormField(
        onChanged: (val) => callback(val),
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xff003670).withOpacity(0.7),
          // border: OutlineInputBorder(),
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Color(0x00003670), width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Color(0x00003670), width: 0),
          ),
        ),
      ),
    );
  }
}

class PasswordInputForm extends StatelessWidget {
  @override
  final Function callback;
  PasswordInputForm({required this.callback});
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: size.width * 0.7,
      child: TextFormField(
        onChanged: (val) => callback(val),
        obscureText: true,
        style: TextStyle(
          color: Color(0xffAFAFAD),
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.27),
          // border: OutlineInputBorder(),
          hintText: 'Password',
          hintStyle: TextStyle(
            color: Color(0xffAFAFAD),
            fontWeight: FontWeight.w600,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Color(0x00003670), width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Color(0x00003670), width: 0),
          ),
        ),
      ),
    );
  }
}

class LoginWrapper extends StatelessWidget {
  final VoidCallback callback;
  LoginWrapper({required this.callback});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(size.width * 0.5, size.height * 0.06),
              primary: Color(0xffD92136).withOpacity(0.65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: callback,
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
