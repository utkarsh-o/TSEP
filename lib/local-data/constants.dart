import 'package:flutter/material.dart';

import '../logic/firestore.dart';

const Color kBlue = Color(0xff003670);
const Color kLightBlue = Color(0xff1F78B4);
const Color kRed = Color(0xffD92136);
const Color kGreen = Color(0xff34A853);

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

List<Lesson> lessonData = [
  Lesson(
    title: 'Introduction',
    url:
        'https://drive.google.com/file/d/1VtElAWHOwn9IVpIGyr_SrEllTBL3phUs/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Routines and Habits',
    url:
        'https://drive.google.com/file/d/1stjNjyus09FtNnVkb6LmUOwYTSnX2Vab/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'About your hobbies',
    url:
        'https://drive.google.com/file/d/1XZZs51f8sLymJp34L4tO9IJZHZ6qU5Y3/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Talking about Past Experiences',
    url:
        'https://drive.google.com/file/d/1Lc1WQl9e9IlrDsGLhD-ZvpkekyFaVf8w/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Describing places',
    url:
        'https://drive.google.com/file/d/1RtfT2q_lFNl5Le8FrJ6uFOtYZVMbrUGe/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'In the news',
    url:
        'https://drive.google.com/file/d/1CjZwp77u3JPRO_YJLz7XvjeDUZZiX9EJ/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Opinions about the news',
    url:
        'https://drive.google.com/file/d/1cT3QOThEkmf3xxZhnLmYmRJF1y6zwr4V/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'About the films',
    url:
        'https://drive.google.com/file/d/1th0ZzDwNCro1EMY7-HtYxhN9DOnQnnf7/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Social Media - Pros and Cons',
    url:
        'https://drive.google.com/file/d/1Vbv6brkkNlffC299qodODlA05X1KA0hG/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Social Media - Dos and Don\'ts',
    url:
        'https://drive.google.com/file/d/1pU2bapxzrNyaPwOUywpxODczfJyHONAG/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Technology then and now',
    url:
        'https://drive.google.com/file/d/1xFXotogaI5dykz2yNY3KE9u1eRYct2t2/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Global cities and workplaces',
    url:
        'https://drive.google.com/file/d/1DDN9R6Q6JhEnI555mBHWLU3kRIL3rmV_/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Planning for the future',
    url:
        'https://drive.google.com/file/d/1qaY9i7WxNdUdFFmtCyWvjMN1fSOoQxRP/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Time management',
    url:
        'https://drive.google.com/file/d/1BI4d64wPPs2NBID01wDoSdV5_I7RtVj5/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Mumbai 2050',
    url:
        'https://drive.google.com/file/d/1zCG4kOq2MDtRXaiNxYAh64XNRPebi155/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'What ails our society',
    url:
        'https://drive.google.com/file/d/1yVbc_YI0bEbUYE1a9RDqfDypxKJk2Q2-/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'What we can do as citizens',
    url:
        'https://drive.google.com/file/d/1ECnWtHuVO32yidz6dE60OYbOOmqInDSx/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'My vision for India',
    url:
        'https://drive.google.com/file/d/1Av8JIHrnkyqxhdCcvQFgYFyS-bqTDU7o/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Gender Equality',
    url:
        'https://drive.google.com/file/d/1MGc9r4Gc-W4l9WjDoIE_8WQRtb6MfwcO/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Inclusivity at the workplace',
    url:
        'https://drive.google.com/file/d/1ENulJPyuoqMkSISjL4kfnwN4sU_b54IH/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Conversation to seek information',
    url:
        'https://drive.google.com/file/d/1f6la1QawUPq29cVGFmgKp5Fuc0lBH70h/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'An interview',
    url:
        'https://drive.google.com/file/d/1Sm37Q4yr0G8anT0Se0fw9Yj53yeH-AQl/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Back to the future',
    url:
        'https://drive.google.com/file/d/1k9uS2_QWe1fLvKhmvlb1rPFcjHOWauhh/view?usp=sharing',
    duration: '30mins',
  ),
  Lesson(
    title: 'Imagine and Predict',
    url:
        'https://drive.google.com/file/d/1VsnT9XjVSfoTKl9dLSY75JG1VrBaaDyd/view?usp=sharing',
    duration: '30mins',
  ),
];
