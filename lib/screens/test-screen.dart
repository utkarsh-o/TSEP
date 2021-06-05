import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleBar(),
            MenteeProfileBanner(),
            BreakLine(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [LevelCard(), CurrentScoreCard()],
              ),
            ),
            BreakLine(),
            Container(
              child: Column(
                children: [
                  QuestionCard(size: size),
                  SizedBox(
                    height: 25,
                  ),
                  ScoreCard(size: size),
                  SizedBox(
                    height: 25,
                  ),
                  AnsCard(size: size)
                ],
              ),
            ),
            BreakLine(),
            DecComRepDropContainer()
          ],
        ),
      ),
    );
  }
}

class AnsCard extends StatelessWidget {
  const AnsCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.25,
      width: size.width * 0.85,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xff1F78B4).withOpacity(0.8), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "I went on a hike with my friends on our bicycles last weekend and had kulfi on our way back.",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff1F78B4).withOpacity(0.4),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6),
          ),
          height: size.height * 0.05,
          width: size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScoreNum(num: 0, active: false),
              ScoreNum(num: 1, active: false),
              ScoreNum(num: 2, active: true),
              ScoreNum(num: 3, active: false),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/info-btn.svg",
            height: 30,
          ),
        ),
      ],
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 35,
          width: 40,
          margin: EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: Color(0xffD92136).withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0xffD92136).withOpacity(0.7),
                blurRadius: 7,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "4",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.7),
          child: Text(
            "Tell me something you did with your friends recently",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}

class ScoreNum extends StatelessWidget {
  final int num;
  final bool active;
  ScoreNum({required this.num, required this.active});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: active
          ? BoxDecoration(
              color: Color(0xff1F78B4).withOpacity(1),
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: Text(
        num.toString(),
        style: TextStyle(
          color: active ? Colors.white : Colors.black.withOpacity(0.8),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }
}

class CurrentScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Text(
            "Current Score",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6,
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xffD92136), width: 2),
                ),
                height: size.height * 0.05,
                width: size.width * 0.4,
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffD92136).withOpacity(1),
                          blurRadius: 10,
                        )
                      ],
                      color: Color(0xffD92136),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: size.height * 0.05,
                    width: size.width * 0.4 * 0.6,
                  ),
                  Positioned(
                    top: size.height * 0.05 * 0.2,
                    right: 8,
                    child: Text(
                      "8 / 12",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Text(
            "Current Level",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff1F78B4).withOpacity(0.08),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1F78B4).withOpacity(0.4),
                  blurRadius: 4,
                )
              ],
            ),
            height: size.height * 0.05,
            width: size.width * 0.4,
            child: Center(
              child: Text(
                "INTERMEDIATE",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff003670),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MenteeProfileBanner extends StatelessWidget {
  const MenteeProfileBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Spider Man",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                "+91 9876543210",
                style: TextStyle(
                    color: Color(0xff269200),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          DetailsWidget(heading: "Type", value: "Pre-Programmed"),
          DetailsWidget(heading: "Batch", value: "B72"),
          DetailsWidget(heading: "Age", value: "17"),
        ],
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final String heading, value;
  DetailsWidget({required this.heading, required this.value});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          heading,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height * 0.005,
        ),
        Text(
          value,
          style: TextStyle(
            color: Color(0xffD92136).withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
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
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/back-tb.svg",
              height: screenWidth * 0.07,
            ),
          ),
        ),
        Container(
          child: Text(
            "Test-Form",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.42,
          height: screenHeight * 0.12,
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/edit-tb.svg",
            height: screenWidth * 0.07,
          ),
        ),
      ],
    );
  }
}

class BreakLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 1,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Color(0xff003670).withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class DecComRepDropContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Center(
              child: Text(
                "PREVIOUS",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            height: size.height * 0.07,
            width: size.width * 0.4,
            decoration: BoxDecoration(
              color: Color(0xffD92136).withOpacity(0.7),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffD92136).withOpacity(0.7),
                  blurRadius: 10,
                )
              ],
            ),
          ),
          Container(
            child: Center(
              child: Text(
                "NEXT",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            height: size.height * 0.07,
            width: size.width * 0.4,
            decoration: BoxDecoration(
              color: Color(0xff1F78B4),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1F78B4),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
