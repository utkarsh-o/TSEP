class Schedule {
  String mentee, lesson;
  DateTime timing;
  int duration;

  Schedule({
    required this.mentee,
    required this.lesson,
    required this.duration,
    required this.timing,
  });
}

List<Schedule> schedule = [
  Schedule(
    mentee: 'Iron Man',
    lesson: 'lesson 6',
    duration: 60,
    timing: DateTime.parse('2021-06-19 16:00:00'),
  ),
  Schedule(
    mentee: 'Spider Man',
    lesson: 'lesson 5',
    duration: 30,
    timing: DateTime.parse('2021-06-17 15:00:00'),
  ),
  Schedule(
    mentee: 'Bat Man',
    lesson: 'lesson 3',
    duration: 50,
    timing: DateTime.parse('2021-06-16 18:30:00'),
  ),
  Schedule(
    mentee: 'Ant Man',
    lesson: 'lesson 2',
    duration: 50,
    timing: DateTime.parse('2021-06-14 17:30:00'),
  ),
];
int ttllsns = 0;
Duration getttlctr(List<Schedule> schedule) {
  Duration ttlctr = Duration();
  DateTime today = DateTime.now();
  ttllsns = 0;
  for (var s in schedule)
    if (s.timing.isBefore(today)) {
      ttlctr += Duration(minutes: s.duration);
      ttllsns++;
    }
  return ttlctr;
}

bool iseventful(List<Schedule> schedule, DateTime today) {
  for (var s in schedule)
    if (s.timing.day == today.day &&
        s.timing.month == today.month &&
        s.timing.year == today.year) return true;
  return false;
}

bool isactive(DateTime date) {
  DateTime today = DateTime.now();
  if (today.year == date.year &&
      today.day == date.day &&
      today.month == date.month) return true;
  return false;
}
