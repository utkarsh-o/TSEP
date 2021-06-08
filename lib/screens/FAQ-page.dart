import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/local-data/FAQ.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getFAQList() {
      List<Widget> FAQList = [];
      for (var index = 0; index < _faqs.length; index++) {
        FAQList.add(new QACard(
            index: index + 1,
            question: _faqs[index].question,
            answer: _faqs[index].answer));
      }
      return new Column(children: FAQList);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              TitleBar(),
              getFAQList(),
            ],
          ),
        ),
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
            "Frequently Asked Questions",
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

class QACard extends StatelessWidget {
  int index;
  String answer =
      "Mentees are from weaker sections of society, trying to pursue higher education, wants to enhance the skills in communicative English, wants to become confident to face the challenges in today's world and to make a career.\nThe mentees are the beneficiaries of Kotak Education Foundation's (KEF) Livelihood and Hardship Scholarship programmes. between the age group 18 to 25 years.";
  String question = "What is the background of the mentees?";
  QACard({required this.question, required this.answer, required this.index});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        width: size.width * 0.85,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: size.height * 0.025, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: size.width * 0.04),
                    height: 35,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color(0xff003670).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff003670).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        index.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  Container(
                    child: Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: double.infinity),
              margin: EdgeInsets.only(
                  top: size.height * 0.020,
                  bottom: size.height * 0.025,
                  left: size.width * 0.05,
                  right: size.width * 0.03),
              child: Text(
                answer,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<FAQ> _faqs = [
  FAQ(
      question: 'What is the Full form of TSEP?',
      answer: 'Telephonic Spoken English Programme'),
  FAQ(
      question: 'What is the duration of the programme?',
      answer:
          'Duration of the programme is 10 weeks. The mentor/Trainer needs to call his /her mentee/trainee thrice a week. Per session duration will be 30 min.'),
  FAQ(
      question: 'What is the background of the mentees?',
      answer:
          'Mentees are from weaker sections of society, trying to pursue higher education, wants to enhance the skills in communicative English, wants to become confident to face the challenges in today\'s world and to make a career. The mentees are the beneficiaries of Kotak Education Foundation\'s (KEF) Livelihood and Hardship Scholarship programmes. between the age group 18 to 25 years.'),
  FAQ(
      question: 'Who can enroll in the programme as a mentor?',
      answer:
          'The person with good spoken English skills, who is passionate, committed and wants to give back to society by sparing some of the valuable time that can enroll for the programme as a mentor.'),
  FAQ(question: 'Will there be any assessment for a mentor?', answer: 'No'),
  FAQ(
      question:
          'Is the curriculum and lessons that need to be covered provided by KEF?',
      answer:
          'Yes, Curriculum content and Lesson Plans will be provided by KEF. After the registration, there will be an orientation on Curriculum content and Lesson Plan. The curriculum content and lesson plans will be mailed to the mentors. In addition to the KEF‘s curriculum content, the mentor is free to use any other material which he feels appropriate to use for his mentee.'),
  FAQ(
      question: ' What will be the support of KEF during the programme?',
      answer:
          'There will be KEF POC and the Core committee member assign to each mentor. WhatsApp groups can be formed for easy and fast communications.'),
  FAQ(
      question:
          ' Will the mentor get the certificate after the completion of the programme?',
      answer: 'Yes'),
  FAQ(
      question:
          ' If the mentor, is unable to continue the programme, what he/she should do?',
      answer: 'Mentor should inform his KEF POC in advance.'),
  FAQ(
      question: ' Is there any mechanism to track the programme?',
      answer:
          'The mentor has to fill the log sheet after every session. The log sheet link will be provided. Once the programme starts, KEF POCs and assigned core committee members will communicate with the mentors after certain intervals.'),
  FAQ(
      question:
          'Will there be any Post Test after completion of the programme?',
      answer: 'Yes'),
  FAQ(
      question: 'What is the Expected Outcome?',
      answer: 'There should be a one level jump.'),
];
