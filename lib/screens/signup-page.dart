import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/loading.dart';
import '../local-data/constants.dart';
import '../screens/login-page.dart';

class SignUp extends StatefulWidget {
  static String route = "SignUp";
  @override
  _SignUpState createState() => _SignUpState();
}

bool loading = false;
String email = '',
    password = '',
    batch = '',
    firstName = '',
    lastName = '',
    organization = '',
    gender = 'male';
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController organizationController = TextEditingController();
TextEditingController batchController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String? uid = '';
GlobalKey<FormState> _emailSignUpKey = GlobalKey<FormState>();
GlobalKey<FormState> _passwordSingUpKey = GlobalKey<FormState>();

class _SignUpState extends State<SignUp> {
  void genderCallback(String inputGender) {
    setState(() {
      gender = inputGender;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameController.clear();
    lastNameController.clear();
    organizationController.clear();
    batchController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void singUpCallback() async {
    if (!_emailSignUpKey.currentState!.validate()) {
      return;
    }
    if (!_passwordSingUpKey.currentState!.validate()) {
      return;
    }
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    try {
      print(emailController.text);
      print(passwordController.text);
      print(firstNameController.text);
      print(lastNameController.text);
      print(organizationController.text);
      print(batchController.text);
      setState(() {
        loading = true;
      });
      final newUser = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (newUser.user != null) {
        uid = newUser.user?.uid;
        setState(() {
          loading = false;
        });
        await firestore.collection('/MentorData').doc(uid).set({
          'BatchName': batchController.text,
          'FirstName': firstNameController.text,
          'IDNumber': -1,
          'JoiningDate': Timestamp.fromDate(DateTime.now()),
          'LastName': lastNameController.text,
          'Organization': organizationController.text,
          'email': emailController.text,
          'Gender': gender,
        });
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      setState(() {
        loading = false;
      });
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
                    AvatarWrapper(
                        genderCallback: genderCallback, gender: gender),
                    NameWrapper(),
                    OrganizationBatchWrapper(),
                    EmailInputForm(),
                    PasswordInputForm(),
                    LoginWrapper(callback: singUpCallback)
                  ],
                ),
              ),
            ),
          );
  }
}

class AvatarWrapper extends StatefulWidget {
  final String gender;
  final Function genderCallback;
  AvatarWrapper({required this.gender, required this.genderCallback});
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
              onTap: () => widget.genderCallback("female"),
              child: Container(
                child: Image.asset(
                  'assets/vectors/Mentor(F).png',
                  width: size.width * 0.3,
                ),
                decoration: widget.gender == 'female'
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kRed.withOpacity(0.8),
                            blurRadius: 45,
                          )
                        ],
                      )
                    : null,
              ),
            ),
            InkWell(
              onTap: () => widget.genderCallback("male"),
              child: Container(
                child: Image.asset(
                  'assets/vectors/Mentor(M).png',
                  width: size.width * 0.2,
                ),
                decoration: widget.gender == 'male'
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kBlue.withOpacity(0.8),
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
                padding: EdgeInsets.symmetric(horizontal: 5),
                margin: EdgeInsets.only(top: 7),
                width: size.width * 0.45,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: kRed.withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: kRed.withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: firstNameController,
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
                      // fontSize: size.width * 0.037,
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
                    color: kRed.withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: kRed.withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: lastNameController,
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

class OrganizationBatchWrapper extends StatelessWidget {
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
                    color: kBlue.withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: kBlue.withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: organizationController,
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
                    color: kBlue.withOpacity(0.7),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: kBlue.withOpacity(0.7),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: batchController,
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
                    hintText: "APR2021",
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 25),
      width: size.width * 0.7,
      child: Form(
        key: _emailSignUpKey,
        child: TextFormField(
          controller: emailController,
          validator: (String? val) {
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
          },
          keyboardType: TextInputType.emailAddress,
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
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: kBlue, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: kBlue, width: 0),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordInputForm extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: size.width * 0.7,
      child: Form(
        key: _passwordSingUpKey,
        child: TextFormField(
          controller: passwordController,
          validator: (String? val) {
            String value = val ?? 'test';
            if (value.isEmpty || value == 'test') {
              return 'Please input password';
            }
            if (value.length < 6) {
              return 'Minimum 6 characters needed';
            } else
              return null;
          },
          obscureText: true,
          style: TextStyle(
            color: Color(0xffAFAFAD),
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.27),
            hintText: 'Password',
            hintStyle: TextStyle(
              color: Color(0xffAFAFAD),
              fontWeight: FontWeight.w600,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: kBlue, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: kBlue, width: 0),
            ),
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
              primary: kRed.withOpacity(0.65),
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
