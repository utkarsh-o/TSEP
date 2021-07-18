import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../components/loading.dart';
import '../local-data/constants.dart';
import '../logic/mentor-data-processing.dart';

class MenteeSignUp extends StatefulWidget {
  static String route = "MenteeSignUp";

  @override
  _MenteeSignUpState createState() => _MenteeSignUpState();
}

bool loading = false;
String gender = 'none';
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController qualificationController = TextEditingController();
TextEditingController subDivisionController = TextEditingController();
TextEditingController ageController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController whatsappNumberController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String? uid = '';
GlobalKey<FormState> _emailSignUpKey = GlobalKey<FormState>();
GlobalKey<FormState> _passwordSingUpKey = GlobalKey<FormState>();

List<String> interventionList = [
  'UNNATI',
  'EXCEL',
  'GURU',
  'LEAD',
  'PARVARISH',
  'HEALTH',
  'SCD',
  'HR & ADMIN',
  'ACCOUNTS',
  'DLS',
  'INDIVIDUAL'
];
String? selectedIntervention = interventionList.first;
List<String> subDivisionList = ['BFSI', 'CRS', 'HOSPITALITY'];
String? selectedSubDivision = subDivisionList.first;

class _MenteeSignUpState extends State<MenteeSignUp> {
  void genderCallback(String inputGender) {
    setState(() {
      gender = inputGender;
    });
  }

  @override
  void initState() {
    super.initState();
    gender = 'none';
    firstNameController.clear();
    lastNameController.clear();
    qualificationController.clear();
    emailController.clear();
    passwordController.clear();
    ageController.clear();
    phoneNumberController.clear();
    whatsappNumberController.clear();
    qualificationController.clear();
  }

  void signUpCallback() async {
    if (gender == 'none') {
      showSnackBar(context, 'Please choose your gender');
      return;
    } else if (firstNameController.text == '') {
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
    } else if (qualificationController.text == '') {
      showSnackBar(context, 'Please enter an Qualification');
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
        String batch = selectedIntervention == interventionList.first
            ? '${DateFormat(' MMMyy').format(DateTime.now()).toUpperCase()} $selectedIntervention$selectedSubDivision'
            : '${DateFormat(' MMMyy').format(DateTime.now()).toUpperCase()} $selectedIntervention';
        int age = parseIntFromString('${ageController.text}');
        String? subdivision = selectedIntervention == interventionList.first
            ? selectedSubDivision
            : 'NA';
        await firestore.collection('MenteeInfo').doc(uid).set({
          'BatchName': batch,
          'FirstName': firstNameController.text,
          'IDNumber': -1,
          'JoiningDate': Timestamp.fromDate(DateTime.now()),
          'LastName': lastNameController.text,
          'Qualification': qualificationController.text,
          'email': emailController.text,
          'Gender': gender,
          'Age': age,
          'PhoneNumber': phoneNumber,
          'WhatsappNumber': whatsappNumber,
          'InitialLevel': 'TBD',
          'PreTestScore': -1,
          'MentorUID': '',
          'Intervention': selectedIntervention,
          'SubDivision': subdivision,
        });
        firestore.collection('Logs').add({
          'Event': 'New Mentee SignUp',
          'OldData': 'Does not exist',
          'NewData': {
            'BatchName': batch,
            'FirstName': firstNameController.text,
            'IDNumber': -1,
            'JoiningDate': Timestamp.fromDate(DateTime.now()),
            'LastName': lastNameController.text,
            'Qualification': qualificationController.text,
            'email': emailController.text,
            'Gender': gender,
            'Age': age,
            'PhoneNumber': phoneNumber,
            'WhatsappNumber': whatsappNumber,
            'InitialLevel': 'TBD',
            'MentorUID': '',
            'Intervention': selectedIntervention,
            'SubDivision': subdivision,
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
                    GenderWrapper(
                        genderCallback: genderCallback, gender: gender),
                    NameAgePhoneWrapper(),
                    InterventionBatchWrapper(),
                    EmailPasswordForm(),
                    LoginWrapper(callback: signUpCallback)
                  ],
                ),
              ),
            ),
          );
  }
}

class GenderWrapper extends StatefulWidget {
  final String gender;
  final Function genderCallback;

  GenderWrapper({required this.gender, required this.genderCallback});

  @override
  _GenderWrapperState createState() => _GenderWrapperState();
}

class _GenderWrapperState extends State<GenderWrapper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 30, bottom: 10),
          child: Text(
            "Gender",
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
          AutofillGroup(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RedBorderTextField(
                  heading: "First Name",
                  controller: firstNameController,
                  autofillHints: [AutofillHints.givenName],
                  hint: gender == 'male' ? "Tanmay" : 'Riya',
                  prefixIcon: true,
                  width: size.width * 0.45,
                ),
                RedBorderTextField(
                  heading: "Last Name",
                  controller: lastNameController,
                  autofillHints: [AutofillHints.familyName],
                  hint: gender == 'male' ? "Agrawal" : 'Kapoor',
                  prefixIcon: false,
                  width: size.width * 0.45,
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RedBorderTextField(
                heading: "Age",
                controller: ageController,
                autofillHints: [],
                hint: "16",
                prefixIcon: false,
                width: size.width * 0.15,
              ),
              RedBorderTextField(
                heading: "Phone Number",
                controller: phoneNumberController,
                autofillHints: [AutofillHints.telephoneNumberNational],
                hint: "9876543210",
                prefixIcon: false,
                width: size.width * 0.35,
              ),
              RedBorderTextField(
                heading: "Whatsapp Number",
                controller: whatsappNumberController,
                autofillHints: [AutofillHints.telephoneNumberNational],
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
  List<String> autofillHints;
  bool prefixIcon;
  double width;

  RedBorderTextField(
      {required this.heading,
      required this.controller,
      required this.hint,
      required this.autofillHints,
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
            autofillHints: autofillHints,
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

class InterventionBatchWrapper extends StatefulWidget {
  @override
  _InterventionBatchWrapperState createState() =>
      _InterventionBatchWrapperState();
}

class _InterventionBatchWrapperState extends State<InterventionBatchWrapper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: selectedIntervention == interventionList.first
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              blueDropDownMenu(
                heading: 'Intervention',
                value: selectedIntervention,
                items: interventionList.map((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedIntervention = value;
                  });
                },
              ),
              Visibility(
                visible: selectedIntervention == interventionList.first,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.01),
                    blueDropDownMenu(
                      heading: 'Sub-Division',
                      value: selectedSubDivision,
                      items: subDivisionList.map((String value) {
                        return DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedSubDivision = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          BlueTextFieldWithoutIcon(
              heading: 'Qualification',
              controller: qualificationController,
              hint: '10th Pass')
        ],
      ),
    );
  }
}

class blueDropDownMenu extends StatelessWidget {
  String heading;
  String? value;
  final items;
  final onChanged;
  blueDropDownMenu(
      {required this.heading,
      required this.onChanged,
      required this.items,
      required this.value});
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
          padding: EdgeInsets.symmetric(horizontal: 8),
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
          child: DropdownButton(
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.037,
              color: Colors.black.withOpacity(0.7),
            ),
            // style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.grey,
            //     fontFamily: 'Montserrat'),
            isExpanded: true,
            value: value,
            items: items,
            onChanged: onChanged,
            underline: Container(
              height: 0,
            ),
          ),
        )
      ],
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

class BlueTextFieldWithoutIcon extends StatelessWidget {
  String heading, hint;
  TextEditingController controller;

  BlueTextFieldWithoutIcon({
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
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              "assets/icons/back-tb.svg",
              height: screenWidth * 0.07,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.05, height: screenHeight * 0.12),
        Container(
          child: Text(
            "Mentee Sign Up",
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

class EmailPasswordForm extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AutofillGroup(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            width: size.width * 0.7,
            child: Form(
              key: _emailSignUpKey,
              child: TextFormField(
                controller: emailController,
                autofillHints: [AutofillHints.email],
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
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: size.width * 0.7,
            child: Form(
              key: _passwordSingUpKey,
              child: TextFormField(
                controller: passwordController,
                autofillHints: [AutofillHints.password],
                onEditingComplete: () => TextInput.finishAutofillContext(),
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
          )
        ],
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
