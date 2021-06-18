import 'firestore.dart';

String mentorUID = '';
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

List<Schedule> mentorSchedule = [];
List<Mentee> menteesList = [];

MentorScheduleData mentorScheduleData = MentorScheduleData(
  nextInteraction: Duration(seconds: 0),
  lastInteraction: Duration(seconds: 0),
  hoursPerWeek: 0,
  lecturesPerWeek: 0,
);
