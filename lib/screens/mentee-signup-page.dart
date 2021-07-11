import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/loading.dart';
import '../local-data/constants.dart';
import '../logic/mentor-data-processing.dart';

class MenteeSignUp extends StatefulWidget {
  static String route = "MenteeSignUp";

  @override
  _MenteeSignUpState createState() => _MenteeSignUpState();
}

bool loading = false;
String gender = 'male';
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController organizationController = TextEditingController();
TextEditingController batchController = TextEditingController();
TextEditingController ageController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController whatsappNumberController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String? uid = '';
GlobalKey<FormState> _emailSignUpKey = GlobalKey<FormState>();
GlobalKey<FormState> _passwordSingUpKey = GlobalKey<FormState>();

class _MenteeSignUpState extends State<MenteeSignUp> {
  void genderCallback(String inputGender) {
    setState(() {
      gender = inputGender;
    });
  }

  @override
  void initState() {
    super.initState();
    firstNameController.clear();
    lastNameController.clear();
    organizationController.clear();
    batchController.clear();
    emailController.clear();
    passwordController.clear();
    ageController.clear();
    phoneNumberController.clear();
    whatsappNumberController.clear();
    organizationController.clear();
  }

  void singUpCallback() async {
    if (firstNameController.text == '') {
      showSnackBar(context, 'Please enter a First Name');
      return;
    } else if (lastNameController.text == '') {
      showSnackBar(context, 'Please enter a Last Name');
      return;
    } else if (ageController.text == '') {
      showSnackBar(context, 'Please enter your age');
      return;
    } else if (phoneNumberController.text == '') {
      showSnackBar(context, 'Please enter your phone number');
      return;
    } else if (organizationController.text == '') {
      showSnackBar(context, 'Please enter an Organization');
      return;
    } else if (batchController.text == '') {
      showSnackBar(context, 'Please enter your Batch');
      return;
    }
    if (!_emailSignUpKey.currentState!.validate()) {
      return;
    }
    if (!_passwordSingUpKey.currentState!.validate()) {
      return;
    }
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    try {
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
        int phoneNumber = parseIntFromString('${phoneNumberController.text}');
        int whatsappNumber = whatsappNumberController.text == ''
            ? phoneNumber
            : parseIntFromString('${whatsappNumberController.text}');
        int age = parseIntFromString('${ageController.text}');
        await firestore.collection('MenteeInfo').doc(uid).set({
          'BatchName': batchController.text,
          'FirstName': firstNameController.text,
          'IDNumber': -1,
          'JoiningDate': Timestamp.fromDate(DateTime.now()),
          'LastName': lastNameController.text,
          'Organization': organizationController.text,
          'email': emailController.text,
          'Gender': gender,
          'Age': age,
          'PhoneNumber': phoneNumber,
          'WhatsappNumber': whatsappNumber,
          'InitialLevel': 'TBD',
          'MentorUID': '',
        });
        firestore.collection('Logs').add({
          'Event': 'New Mentee SignUp',
          'OldData': 'Does not exist',
          'NewData': {
            'BatchName': batchController.text,
            'FirstName': firstNameController.text,
            'IDNumber': -1,
            'JoiningDate': Timestamp.fromDate(DateTime.now()),
            'LastName': lastNameController.text,
            'Organization': organizationController.text,
            'email': emailController.text,
            'Gender': gender,
            'Age': age,
            'PhoneNumber': phoneNumber,
            'WhatsappNumber': whatsappNumber,
            'InitialLevel': 'TBD',
            'MentorUID': '',
          },
          'UID': uid,
          'MenteeName':
              '${firstNameController.text} ${lastNameController.text}',
          'DateModified': DateTime.now(),
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
                    NameAgePhoneWrapper(),
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
            Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: InkWell(
                onTap: () => widget.genderCallback("female"),
                child: Container(
                  child: Image.asset(
                    'assets/vectors/Mentee(F)happy.png',
                    height: size.width * 0.3,
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
            ),
            Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: InkWell(
                onTap: () => widget.genderCallback("male"),
                child: Container(
                  child: Image.asset(
                    'assets/vectors/Mentee(M)happy.png',
                    height: size.width * 0.3,
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
            ),
          ],
        ),
      ],
    );
  }
}

class NameAgePhoneWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RedBorderTextField(
                heading: "First Name",
                controller: firstNameController,
                hint: "Tanmay",
                prefixIcon: true,
                width: size.width * 0.45,
              ),
              RedBorderTextField(
                heading: "Last Name",
                controller: lastNameController,
                hint: "Agrawal",
                prefixIcon: false,
                width: size.width * 0.45,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RedBorderTextField(
                heading: "Age",
                controller: ageController,
                hint: "16",
                prefixIcon: false,
                width: size.width * 0.15,
              ),
              RedBorderTextField(
                heading: "Phone Number",
                controller: phoneNumberController,
                hint: "9876543210",
                prefixIcon: false,
                width: size.width * 0.35,
              ),
              RedBorderTextField(
                heading: "Whatsapp Number",
                controller: whatsappNumberController,
                hint: "9876543210",
                prefixIcon: false,
                width: size.width * 0.35,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RedBorderTextField extends StatelessWidget {
  String heading, hint;
  TextEditingController controller;
  bool prefixIcon;
  double width;

  RedBorderTextField(
      {required this.heading,
      required this.controller,
      required this.hint,
      required this.prefixIcon,
      required this.width});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
        ),
        Container(
          alignment: Alignment.center,
          padding: !prefixIcon ? EdgeInsets.only(left: 15) : null,
          margin: EdgeInsets.only(top: 7),
          width: width,
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
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.037,
              color: Colors.black.withOpacity(0.7),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              prefixIcon: prefixIcon
                  ? Icon(
                      Icons.account_circle,
                      color: Colors.black.withOpacity(0.6),
                    )
                  : null,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
                fontSize: size.width * 0.037,
              ),
            ),
          ),
        )
      ],
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
          BlueTextFieldWithIcon(
            heading: 'Organization / School',
            hint: 'Individual',
            controller: organizationController,
            prefixIcon: Icon(
              Icons.card_travel,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          BlueTextFieldWithIcon(
            heading: 'Batch',
            hint: 'APR2021',
            controller: batchController,
            prefixIcon: Icon(
              Icons.today,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class BlueTextFieldWithIcon extends StatelessWidget {
  String heading, hint;
  TextEditingController controller;
  Icon prefixIcon;

  BlueTextFieldWithIcon(
      {required this.heading,
      required this.controller,
      required this.hint,
      required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
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
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.037,
              color: Colors.black.withOpacity(0.7),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              prefixIcon: prefixIcon,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
                fontSize: size.width * 0.037,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class blueTextFieldWithoutIcon extends StatelessWidget {
  String heading, hint;
  TextEditingController controller;

  blueTextFieldWithoutIcon({
    required this.heading,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
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
            controller: controller,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.037,
              color: Colors.black.withOpacity(0.7),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
                fontSize: size.width * 0.037,
              ),
            ),
          ),
        )
      ],
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
        SizedBox(width: screenWidth * 0.05, height: screenHeight * 0.12),
        Container(
          child: Text(
            "Mentee Sing Up",
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
              borderSide: BorderSide(color: Color(0xffAFAFAD), width: 0),
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
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
