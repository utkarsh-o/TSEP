import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuidelinesPage extends StatelessWidget {
  const GuidelinesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleBar(),
            MainBody(),
          ],
        ),
      ),
    );
  }
}

class MainBody extends StatelessWidget {
  String body =
      "\*	Practice active listening.\n\*	Provide information and share knoWledge.\n\*	Provide support and encouragement.\n\*	Give importance to words for a suitable word bank to be built.\n\*	Simple and easy topics pertaining to general knowledge and current affairs can be discussed.\n\*	Encourage the mentee to open up and talk only in English.\n\*	Offer a different perspective while encouraging self-reflection.\n\*	Please do not get emotionally involved and do not encourage personal talk\n\*	Any supporting information and advice can be shared only where professional skills are concerned.\n\*	Adhere to time as time is precious.\n\*	If there is a problem with your mentee that is beyond your scope please contact the Convener of the programme.\n\*	Form a WhatsApp group to help the mentee to summarize the day session or to clear the doubts due to the paucity of time.\n\*	The mentor can be flee to share motivational videos or stories relating to help the mentees.\n";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        width: size.width * 0.9,
        // height: size.height * 0.7,
        decoration: BoxDecoration(
          // color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blueGrey),
        ),
        child: Column(
          children: [
            Text(
              "The below guidelines are to help you in your mentoring process",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "$body",
              style: TextStyle(
                height: 1.4,
                fontWeight: FontWeight.w600,
                fontSize: size.height * 0.0155,
                // wordSpacing: 1,
              ),
            ),
            Text(
              "Hope these guidelines will be of help to achieve the best results for our mentees and we are sure we can count on your committed time and efforts.",
              style: TextStyle(
                fontSize: size.height * 0.0165,
                fontWeight: FontWeight.bold,
                color: Color(0xffA00D1E).withOpacity(0.85),
                shadows: [
                  Shadow(
                    color: Color(0xffA00D1E).withOpacity(0.45),
                    blurRadius: 30,
                  ),
                ],
              ),
            )
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
            "Guidelines",
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
