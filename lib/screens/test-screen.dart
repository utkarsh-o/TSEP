import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsep/local-data/questions.dart';
import 'package:tsep/screens/mentor-profile.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int atvscr = 0, currentScored = 0, currentMax = 0;
  var scores = List<int>.generate(10, (index) => 0);
  var checked = List<bool>.generate(10, (index) => false);
  Question question = new Question();
  int qtnIdx = 0;

  void nxtclb() {
    setState(() {
      // if (qtnIdx >= 10) qtnIdx = 9;
      if (checked[qtnIdx]) {
        atvscr = scores[qtnIdx];
      } else {
        atvscr = 0;
        checked[qtnIdx] = true;
      }
      qtnIdx += qtnIdx + 1 > 9 ? 0 : 1;
      updtTotalScores();
    });
    print(scores);
    print(checked);
  }

  void prvclb() {
    setState(() {
      qtnIdx--;
      if (qtnIdx < 0) qtnIdx = 0;
      atvscr = scores[qtnIdx];
      updtTotalScores();
    });
  }

  void updtscr(int score) {
    scores[qtnIdx] = score;
    checked[qtnIdx] = true;
    setState(() {
      atvscr = score;
      updtTotalScores();
    });
  }

  void updtTotalScores() {
    setState(() {
      currentScored = scores.reduce((a, b) => a + b);
      currentMax = checked.where((item) => item == true).length * 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TitleBar(),
              MenteeProfileBanner(),
              BreakLine(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LevelCard(
                      currentMax: currentMax,
                      currentScored: currentScored,
                    ),
                    CurrentScoreCard(
                      totalScored: currentScored,
                      totalmax: currentMax,
                    )
                  ],
                ),
              ),
              BreakLine(),
              Container(
                child: Column(
                  children: [
                    QuestionCard(
                      question: question,
                      idx: qtnIdx,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ScoreCard(
                      question: question,
                      qtnNum: qtnIdx,
                      active: atvscr,
                      updtScr: updtscr,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    AnsCard()
                  ],
                ),
              ),
              BreakLine(),
              PrevNxtBtn(
                prvclb: prvclb,
                nxtclb: nxtclb,
                qtnIdx: qtnIdx,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // alignment: Alignment.center,
      height: size.height * 0.25,
      width: size.width * 0.85,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xff1F78B4).withOpacity(0.8), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          expands: true,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintMaxLines: 5,
            hintText: "Mentee's Response",
            hintStyle: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class ScoreCard extends StatefulWidget {
  int qtnNum, active;
  Question question;
  Function updtScr;
  ScoreCard(
      {required this.qtnNum,
      required this.question,
      required this.active,
      required this.updtScr});

  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  int atv = 0;
  void callback(int index) {
    setState(() {
      widget.active = index;
      widget.updtScr(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Question _question = Question();
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff1F78B4).withOpacity(0.3),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6),
          ),
          height: size.height * 0.045,
          width: size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScoreNum(num: 0, active: widget.active, callback: callback),
              ScoreNum(num: 1, active: widget.active, callback: callback),
              ScoreNum(num: 2, active: widget.active, callback: callback),
              ScoreNum(num: 3, active: widget.active, callback: callback),
            ],
          ),
        ),
        InkWell(
          onTap: () {},
          child: IconButton(
            onPressed: () {
              return showDialogFunc(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/info-btn.svg",
              height: 30,
            ),
          ),
        ),
      ],
    );
  }

  showDialogFunc(context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          // height: 20,
          // width: 20,
          margin: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Marking Scheme",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xffD92136).withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffD92136).withOpacity(1),
                              blurRadius: 10,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "GOT IT",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ScoreDescriptionCard(index: 0, height: size.height * 0.11),
              ScoreDescriptionCard(index: 1, height: size.height * 0.18),
              ScoreDescriptionCard(index: 2, height: size.height * 0.21),
              ScoreDescriptionCard(index: 3, height: size.height * 0.18),
            ],
          ),
        );
      },
    );
  }
}

class ScoreDescriptionCard extends StatelessWidget {
  final int index;
  final double height;
  ScoreDescriptionCard({required this.index, required this.height});
  List<String> markingscheme = [
    "The student does not understand the question, even when it is repeated, or gives the wrong answer or no response.",
    "The student responds in short words/phrases and/or inaccurate answers. The student shows hesitation, a limited range of vocabulary, inability to extend answers and pronunciation that impedes understanding. (Example: eat breakfast, go college)",
    "The student is able to comprehend the question and form longer answers- The student is able to self-correct occasional errors. The student avoids complex vocabulary and their pronunciation is easy to understand.\nExample: I eat breakfast. I go to college",
    "The student is able to comprehend the question and extend their answers using complex vocabulary and grammatical structures where appropriate.\nExample: 1 usually go to college at around 7 am. I eat breakfast and drink some tea.",
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: height,
      width: double.infinity,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff1F78B4),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1F78B4).withOpacity(1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(minWidth: 40),
            height: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Text(
              index.toString(),
              style: TextStyle(
                color: Color(0xff1F78B4),
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ),
          Expanded(
            child: Text(
              markingscheme[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreNum extends StatelessWidget {
  final int num, active;
  final Function callback;
  ScoreNum({required this.num, required this.active, required this.callback});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(num),
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        height: MediaQuery.of(context).size.height * 0.03,
        width: MediaQuery.of(context).size.height * 0.03,
        decoration: active == num
            ? BoxDecoration(
                color: Color(0xff1F78B4).withOpacity(1),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Center(
          child: Text(
            num.toString(),
            // textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  active == num ? Colors.white : Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final int idx;
  final Question question;
  QuestionCard({required this.idx, required this.question});
  @override
  Widget build(BuildContext context) {
    // Question _question = Question();
    Size size = MediaQuery.of(context).size;
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
              (idx + 1).toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.75),
          child: Text(
            question.statement[idx],
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}

class CurrentScoreCard extends StatelessWidget {
  final int totalScored, totalmax;
  CurrentScoreCard({required this.totalScored, required this.totalmax});
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
                alignment: Alignment.centerRight,
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
                    width: totalmax == 0
                        ? 0
                        : size.width * 0.4 * totalScored / totalmax,
                  ),
                  CrntScrScore(
                    totalscored: totalScored,
                    totalmax: totalmax,
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

class CrntScrScore extends StatelessWidget {
  final int totalscored, totalmax;
  CrntScrScore({required this.totalscored, required this.totalmax});
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: totalscored / totalmax >= 7 / 18 ? true : false,
      child: Positioned(
        right: 8,
        child: Text(
          "$totalscored / $totalmax",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final int currentScored, currentMax;
  LevelCard({required this.currentMax, required this.currentScored});
  @override
  Widget build(BuildContext context) {
    var frac = currentScored / currentMax;
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
            width: size.width * 0.45,
            child: Center(
              child: Text(
                frac <= 1 / 3
                    ? "NOVICE"
                    : frac <= 2 / 3
                        ? "PRE-INTERMEDIATE"
                        : "INTERMEDIATE",
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
          DetailsWidget(heading: "Type", value: "Pre-Program"),
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
            onPressed: () {
              Navigator.pop(context);
            },
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

class PrevNxtBtn extends StatelessWidget {
  final VoidCallback prvclb, nxtclb;
  final int qtnIdx;
  PrevNxtBtn(
      {required this.prvclb, required this.nxtclb, required this.qtnIdx});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: prvclb,
            child: Container(
              child: Center(
                child: Text(
                  qtnIdx == 0 ? "EXIT" : "PREVIOUS",
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
          ),
          InkWell(
            onTap: nxtclb,
            child: Container(
              child: Center(
                child: Text(
                  qtnIdx == 9 ? "FINISH" : "NEXT",
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
          ),
        ],
      ),
    );
  }
}
