import 'firestore.dart';

String mentorName = '', mentorEmail = '', mentorUID = '';
MentorProfileData mentorProfileData = MentorProfileData(
  batchName: 'batchName',
  firstName: 'firstName',
  email: 'email',
  gender: 'gender',
  joiningDate: DateTime.now(),
  idNumber: -1,
  lastName: 'lastName',
  organization: 'organization',
);

MentorScheduleData mentorScheduleData = MentorScheduleData(
  nextInteraction: Duration(seconds: 0),
  lastInteraction: Duration(seconds: 0),
  hoursPerWeek: 0,
  lecturesPerWeek: 0,
);

List<Schedule> mentorSchedule = [];
List<Mentee> menteesList = [];
