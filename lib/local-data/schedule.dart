class Schedule {
  String mentee;
  int lesson;
  DateTime timing;
  Duration duration;

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
    lesson: 6,
    duration: Duration(hours: 1),
    timing: DateTime.parse('2021-06-08 16:00:00'),
  ),
  Schedule(
    mentee: 'Spider Man',
    lesson: 3,
    duration: Duration(minutes: 30),
    timing: DateTime.parse('2021-06-09 15:00:00'),
  ),
  Schedule(
    mentee: 'Bat Man',
    lesson: 5,
    duration: Duration(minutes: 50),
    timing: DateTime.parse('2021-06-11 18:30:00'),
  ),
  Schedule(
    mentee: 'Ant Man',
    lesson: 5,
    duration: Duration(minutes: 50),
    timing: DateTime.parse('2021-06-14 14:30:00'),
  ),
];
int ttllsns = 0;
Duration getttlctr(List<Schedule> schedule) {
  Duration ttlctr = Duration();
  DateTime today = DateTime.now();
  ttllsns = 0;
  for (var s in schedule)
    if (s.timing.isBefore(today)) {
      ttlctr += s.duration;
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
