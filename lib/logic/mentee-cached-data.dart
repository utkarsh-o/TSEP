import 'mentee-firestore.dart';

String menteeName = '', menteeEmail = '', menteeUID = '', mentorUID = '';
MenteeProfileData menteeProfileData = MenteeProfileData(
    batchName: '-',
    firstName: '-',
    email: '-',
    gender: '-',
    joiningDate: DateTime.now(),
    idNumber: -1,
    lastName: '-',
    organization: '-',
    phoneNumber: -1,
    whatsappNumber: -1,
    age: -1,
    initialLevel: '-');
MenteeScheduleData menteeScheduleData = MenteeScheduleData(
    nextInteraction: Duration(minutes: 0),
    lastInteraction: Duration(minutes: 0),
    hoursPerWeek: -1,
    lecturesPerWeek: -1);
MentorProfileData mentorProfileData = MentorProfileData(
    firstName: '-',
    email: '-',
    gender: '-',
    lastName: '-',
    phoneNumber: -1,
    whatsappNumber: -1,
    idNumber: -1,
    fullName: '-');
List<Schedule> menteeSchedule = [];
