class Lesson {
  String title;
  String duration;
  Lesson({required this.title, required this.duration});
}

List<Lesson> _lessons = [
  Lesson(duration: "30mins", title: "INTRODUCTION"),
  Lesson(duration: "40mins", title: "Nouns, Prepositions & Verbs"),
];
