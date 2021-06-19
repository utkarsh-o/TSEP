// Just Kept here for reference, using StreamBuilder instead not
// Future<Widget> sync {
//   DateTime today = DateTime.now();
//   DateTime _firstDayOfTheweek =
//       today.subtract(new Duration(days: today.weekday));
//   DateTime startDate = _firstDayOfTheweek.add(Duration(days: 1));
//   DateTime endDate = _firstDayOfTheweek.add(Duration(days: 7));
//   List<Widget> ScheduleList = [];
//   await for (var snapshot
//       in firestore.collection('MentorData/${uid}/Schedule').snapshots()) {
//     for (var schedule in snapshot.docs) {
//       var lectureTime = schedule.get('LectureTime').toDate();
//       if (lectureTime.isAfter(startDate) && lectureTime.isBefore(endDate)) {
//         Schedule s = Schedule(
//           mentee: schedule.get('MenteeName'),
//           lesson: schedule.get('LessonNumber'),
//           duration: schedule.get('Duration'),
//           timing: schedule.get('LectureTime'),
//         );
//         ScheduleList.add(new ScheduleCard(
//           s: s,
//         ));
//       }
//     }
//   }
//   return new ListView(children: ScheduleList);
// }

// Deprecitated, using streamBuilder now !
// Widget getSchedule() {
//   DateTime today = DateTime.now();
//   DateTime _firstDayOfTheweek =
//       today.subtract(new Duration(days: today.weekday));
//   DateTime startDate = _firstDayOfTheweek.add(Duration(days: 1));
//   DateTime endDate = _firstDayOfTheweek.add(Duration(days: 7));
//
//   List<Widget> ScheduleList = [];
//   for (var sche in schedule) {
//     if (sche.timing.isAfter(startDate) && sche.timing.isBefore(endDate))
//       ScheduleList.add(new ScheduleCard(s: sche));
//   }
//   return new ListView(children: ScheduleList);
// }
