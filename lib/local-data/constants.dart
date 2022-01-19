import 'package:flutter/material.dart';
import 'package:tsep/screens/mentee-details-page.dart';

import '../logic/mentor-firestore.dart';

const Color kBlue = Color(0xff003670);
const Color kLightBlue = Color(0xff1F78B4);
const Color kRed = Color(0xffD92136);
const Color kGreen = Color(0xff34A853);

List<Lesson> lessonData = [
  Lesson(
    title: 'Introduction',
    number: 1,
    url:
        'https://drive.google.com/file/d/1VtElAWHOwn9IVpIGyr_SrEllTBL3phUs/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Routines and Habits',
    number: 2,
    url:
        'https://drive.google.com/file/d/1stjNjyus09FtNnVkb6LmUOwYTSnX2Vab/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/dSBIqRYu0PY',
      'https://youtu.be/L9AWrJnhsRI',
      'https://www.elllo.org/english/Mixer126/T150-Badhabit.htm'
    ],
    homeworkLinks: ['https://www.ego4u.com/en/cram-up/tests/simple-present-1'],
  ),
  Lesson(
    title: 'About your hobbies',
    number: 3,
    url:
        'https://drive.google.com/file/d/1XZZs51f8sLymJp34L4tO9IJZHZ6qU5Y3/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/YMTRr4_qNdw',
      'https://youtu.be/-UX0X45sYe4',
      'https://youtu.be/hoyhPZDp3dE',
    ],
  ),
  Lesson(
    title: 'Talking about Past Experiences',
    number: 4,
    url:
        'https://drive.google.com/file/d/1Lc1WQl9e9IlrDsGLhD-ZvpkekyFaVf8w/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/rZS5qlCGCIY',
      'https://youtu.be/3X9zcX6lZtI',
    ],
  ),
  Lesson(
    title: 'Describing places',
    number: 5,
    url:
        'https://drive.google.com/file/d/1RtfT2q_lFNl5Le8FrJ6uFOtYZVMbrUGe/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/illyGhiL2p8',
      'https://youtu.be/qb-m3tEW_as',
      'https://youtu.be/XqYzPmbA8i0',
    ],
    homeworkLinks: [
      'http://www.englishvocabularyexercises.com/eve-exercises/EngVocEx_adjectives_7_2.htm'
    ],
  ),
  Lesson(
    title: 'In the news',
    number: 6,
    url:
        'https://drive.google.com/file/d/1CjZwp77u3JPRO_YJLz7XvjeDUZZiX9EJ/view?usp=sharing',
    duration: '30mins',
    videoLinks: ['https://youtu.be/etvW0FOD_so'],
    homeworkLinks: [
      'https://eslflow.com/wp-content/uploads/2020/03/Past-continuous-worksheet-Q-and-A.pdf'
    ],
  ),
  Lesson(
    title: 'Opinions about the news',
    number: 7,
    url:
        'https://drive.google.com/file/d/1cT3QOThEkmf3xxZhnLmYmRJF1y6zwr4V/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/TbggqzYQhdA',
      'https://youtu.be/I5l7e6oW-GM',
      'https://youtu.be/SRvL9J4k490',
      'https://youtu.be/gsYUKRuphQI',
      'https://youtu.be/aGxOS2RdVBc',
    ],
  ),
  Lesson(
      title: 'About the films',
      number: 8,
      url:
          'https://drive.google.com/file/d/1th0ZzDwNCro1EMY7-HtYxhN9DOnQnnf7/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/DYyU_uD9t0E',
        'https://youtu.be/ovcu9V3uDfw',
        'https://www.eslfast.com/robot/topics/smalltalk/smalltalk11.htm',
        'https://youtu.be/w65e7O1TmM8'
      ]),
  Lesson(
      title: 'Social Media - Pros and Cons',
      number: 9,
      url:
          'https://drive.google.com/file/d/1Vbv6brkkNlffC299qodODlA05X1KA0hG/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/jQ8J3IHhn8A',
        'https://youtu.be/3zQtfnCdcNw'
      ]),
  Lesson(
      title: 'Social Media - Dos and Don\'ts',
      number: 10,
      url:
          'https://drive.google.com/file/d/1pU2bapxzrNyaPwOUywpxODczfJyHONAG/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/u0lk3tremKM',
        'https://youtu.be/MB5VDIebMd8'
      ]),
  Lesson(
    title: 'Technology then and now',
    number: 11,
    url:
        'https://drive.google.com/file/d/1xFXotogaI5dykz2yNY3KE9u1eRYct2t2/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://elllo.org/video/M126/T128-Obsolete.htm',
      'https://youtu.be/DENG7Q7VRgo',
      'https://youtu.be/UDrzuel0ME4',
    ],
  ),
  Lesson(
    title: 'Global cities and workplaces',
    number: 12,
    url:
        'https://drive.google.com/file/d/1DDN9R6Q6JhEnI555mBHWLU3kRIL3rmV_/view?usp=sharing',
    duration: '30mins',
    videoLinks: ['https://youtu.be/wwLaiF_bVpI'],
  ),
  Lesson(
      title: 'Planning for the future',
      number: 13,
      url:
          'https://drive.google.com/file/d/1qaY9i7WxNdUdFFmtCyWvjMN1fSOoQxRP/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/cfNMrfGcZXw',
        'https://youtu.be/QjKS3E0spl8',
      ]),
  Lesson(
    title: 'Time management',
    number: 14,
    url:
        'https://drive.google.com/file/d/1BI4d64wPPs2NBID01wDoSdV5_I7RtVj5/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/F5JI_6nsgaM',
      'https://youtu.be/8AFFPl7KRC8',
      'https://youtu.be/jH8WYW8Qa8o',
    ],
    homeworkLinks: [
      'https://create.kahoot.it/share/time-management/f84179eb-0ce3-4f86-ab5b-01ac1fd74103'
    ],
  ),
  Lesson(
    title: 'Mumbai 2050',
    number: 15,
    url:
        'https://drive.google.com/file/d/1zCG4kOq2MDtRXaiNxYAh64XNRPebi155/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/hz4-LkCEHCU',
    ],
    homeworkLinks: [
      'https://en.islcollective.com/english-esl-worksheets/grammar/future-tenses/will-vs-be-going-key-included/8754'
    ],
  ),
  Lesson(
      title: 'What ails our society',
      number: 16,
      url:
          'https://drive.google.com/file/d/1yVbc_YI0bEbUYE1a9RDqfDypxKJk2Q2-/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/QLSfyeVKD2o',
        'https://www.sociologydiscussion.com/social-change/social-changes-in-india-its-meaning-and-factors/2501',
        'https://youtu.be/6x6ihAFuhco',
      ]),
  Lesson(
      title: 'What we can do as citizens',
      number: 17,
      url:
          'https://drive.google.com/file/d/1ECnWtHuVO32yidz6dE60OYbOOmqInDSx/view?usp=sharing',
      duration: '30mins',
      videoLinks: ['https://youtu.be/YPzFGxmMlqI']),
  Lesson(
      title: 'My vision for India',
      number: 18,
      url:
          'https://drive.google.com/file/d/1Av8JIHrnkyqxhdCcvQFgYFyS-bqTDU7o/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/Qo8SGBdT344',
        'https://youtu.be/dB-RPOHqskU',
        'https://youtu.be/Yitka3CP3TM',
      ]),
  Lesson(
      title: 'Gender Equality',
      number: 19,
      url:
          'https://drive.google.com/file/d/1MGc9r4Gc-W4l9WjDoIE_8WQRtb6MfwcO/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/4viXOGvvu0Y',
        'https://youtu.be/WxhLMC4COmc',
        'https://youtu.be/W-vz0yrE8RY',
      ]),
  Lesson(
      title: 'Inclusivity at the workplace',
      number: 20,
      url:
          'https://drive.google.com/file/d/1ENulJPyuoqMkSISjL4kfnwN4sU_b54IH/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://youtu.be/O-wmulY5Z4o',
        'https://youtu.be/ZujSX_nLYMA',
      ]),
  Lesson(
    title: 'Conversation to seek information',
    number: 21,
    url:
        'https://drive.google.com/file/d/1f6la1QawUPq29cVGFmgKp5Fuc0lBH70h/view?usp=sharing',
    duration: '30mins',
    videoLinks: [
      'https://youtu.be/-_YoeEY8FPM',
      'https://youtu.be/fzKQ69qWhTA',
    ],
    homeworkLinks: [
      'https://create.kahoot.it/share/giving-and-asking-for-directions/3fe26c0d-e551-4528-9842-10816df5ab3d'
    ],
  ),
  Lesson(
    title: 'An interview',
    number: 22,
    url:
        'https://drive.google.com/file/d/1Sm37Q4yr0G8anT0Se0fw9Yj53yeH-AQl/view?usp=sharing',
    duration: '30mins',
    videoLinks: ['https://youtu.be/laGZaS4sdeU'],
    homeworkLinks: [
      'https://create.kahoot.it/share/giving-your-opinion/fe866e1b-be6a-4ffe-8dd6-33344188505b'
    ],
  ),
  Lesson(
      title: 'Back to the future',
      number: 23,
      url:
          'https://drive.google.com/file/d/1k9uS2_QWe1fLvKhmvlb1rPFcjHOWauhh/view?usp=sharing',
      duration: '30mins',
      videoLinks: [
        'https://www.elllo.org/english/news/T19-Fire.html',
        'https://www.elllo.org/english/news/T11-Marathon.html'
      ]),
  Lesson(
      title: 'Imagine and Predict',
      number: 24,
      url:
          'https://drive.google.com/file/d/1VsnT9XjVSfoTKl9dLSY75JG1VrBaaDyd/view?usp=sharing',
      duration: '30mins',
      videoLinks: ['https://youtu.be/rJ3YKh2gHmU']),
];

List<String> markingScheme = [
  "The student does not understand the question, even when it is repeated, or gives the wrong answer or no response.",
  "The student responds in short words/phrases and/or inaccurate answers. The student shows hesitation, a limited range of vocabulary, inability to extend answers and pronunciation that impedes understanding. \nExample: eat breakfast, go college",
  "The student is able to comprehend the question and form longer answers- The student is able to self-correct occasional errors. The student avoids complex vocabulary and their pronunciation is easy to understand.\nExample: I eat breakfast. I go to college",
  "The student is able to comprehend the question and extend their answers using complex vocabulary and grammatical structures where appropriate.\nExample: 1 usually go to college at around 7 am. I eat breakfast and drink some tea.",
];

List<String> questions = [
  'What do you do every day? What time do you get up/start work or college?',
  'What do you do in your free time?',
  'Tell me something which you can do well now.',
  'Tell me something you did with your friends recently.',
  'What are you going to do this weekend?',
  'Tell me about your best friend or someone you admire. What are they like?',
  'Let’s talk about your favorite place. Can you describe your favorite place?',
  'How do you think Mumbai will change in the next 20 years?',
  'What advice would you give to someone visiting Mumbai or India?',
  'Tell me about the main news stories in our country at the moment.',
];

Lesson getLessonByNumber(int number) {
  for (Lesson lesson in lessonData) {
    if (lesson.number == number) return lesson;
  }
  return lessonData.first;
}
