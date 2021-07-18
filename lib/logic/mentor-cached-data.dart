import 'mentor-firestore.dart';

String mentorName = '', mentorEmail = '', mentorUID = '';
Mentor mentorProfileData = Mentor(
    batchName: 'batchName',
    firstName: 'firstName',
    email: 'email',
    gender: 'gender',
    joiningDate: DateTime.now(),
    idNumber: -1,
    lastName: 'lastName',
    category: 'category',
    categoryName: 'categoryName',
    age: -1,
    phoneNumber: 9876543210,
    qualification: 'qualification',
    specialization: 'specialization');

MentorScheduleData mentorScheduleData = MentorScheduleData(
  nextInteraction: Duration(seconds: 0),
  lastInteraction: Duration(seconds: 0),
  hoursPerWeek: 0,
  lecturesPerWeek: 0,
);

List<Schedule> mentorSchedule = [];
List<Mentee> menteesList = [];
