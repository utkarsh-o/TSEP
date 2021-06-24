import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../local-data/FAQ.dart';

class FAQPage extends StatelessWidget {
  static String route = "FAQPage";
  @override
  Widget build(BuildContext context) {
    Widget getFAQList() {
      List<Widget> FAQList = [];
      for (var index = 0; index < faqs.length; index++) {
        FAQList.add(new QACard(
            index: index + 1,
            question: faqs[index].question,
            answer: faqs[index].answer));
      }
      return new ListView(children: FAQList);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleBar(),
            Expanded(
              child: getFAQList(),
            ),
          ],
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
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class QACard extends StatelessWidget {
  int index;
  String answer, question;
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
