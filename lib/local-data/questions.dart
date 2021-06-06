class Question {
  List<String> statement = [
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
  List<String> answer = [];
  List<int> score = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1];
  Question();
}

void main() {
  Question q = Question();
  print(q.statement[0]);
}
