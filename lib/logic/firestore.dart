import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentication.dart';
import 'cached-data.dart';
import 'data-processing.dart';

class ProfileHandler {
  final firestore = FirebaseFirestore.instance;
  final auth = Authentication();
  DateTime joiningDate = DateTime.now();

  String uid = '';

  getData(VoidCallback callback) async {
    await getCurrentUser();
    getMentorScheduleData(callback);
    getMentorProfileData(callback);
    getMenteeData(callback);
  }

  getCurrentUser() async {
    try {
      final User user = await auth.getCurrentUser();
      uid = user.uid;
      mentorUID = uid;
      mentorEmail = user.email ?? 'email';
    } catch (error) {
      print('MentorProfile error -> $error');
    }
  }

  getMentorProfileData(VoidCallback callback) async {
    await for (var snapshot
        in firestore.collection('MentorData').doc(uid).snapshots()) {
      var firstName = snapshot.get('FirstName').toString();
      var lastName = snapshot.get('LastName').toString();
      mentorProfileData = MentorProfileData(
        batchName: snapshot.get('BatchName').toString(),
        firstName: firstName,
        idNumber: snapshot.get('IDNumber'),
        lastName: lastName,
        organization: snapshot.get('Organization').toString(),
        email: snapshot.get('email'),
        joiningDate: snapshot.get('JoiningDate').toDate(),
        gender: snapshot.get('Gender'),
        age: snapshot.get('Age'),
        phoneNumber: snapshot.get('PhoneNumber'),
        qualification: snapshot.get('Qualification'),
        specialization: snapshot.get('Specialization'),
      );
      joiningDate = snapshot.get('JoiningDate').toDate();
      mentorName = "$firstName $lastName";
      callback();
    }
  }

  getMentorScheduleData(VoidCallback callback) async {
    await for (var snapshot in firestore
        .collection('MentorData/$uid/Schedule')
        .orderBy('LectureTime')
        .snapshots()) {
      mentorSchedule.clear();
      final schedules = snapshot.docs;
      for (var schedule in schedules) {
        Schedule sch = Schedule(
          mentee: schedule.get('MenteeName'),
          lesson: schedule.get('LessonNumber'),
          duration: schedule.get('Duration'),
          timing: schedule.get('LectureTime').toDate(),
          mentorScheduleID: schedule.id,
          menteeScheduleID: schedule.get('MenteeScheduleID'),
          menteeUID: schedule.get('MenteeUID'),
          postSessionSurvey: schedule.get('PostSessionSurvey'),
          footNotes: schedule.get('FootNotes'),
        );
        mentorSchedule.add(sch);
      }
      mentorScheduleData = MentorScheduleData(
        nextInteraction: getNextInteraction(mentorSchedule),
        lastInteraction: getLastInteraction(mentorSchedule),
        hoursPerWeek: getLectureHourRate(joiningDate, mentorSchedule).last,
        lecturesPerWeek: getLectureHourRate(joiningDate, mentorSchedule).first,
      );
      callback();
    }
  }

  getMenteeData(VoidCallback callback) async {
    await for (var snapshot in firestore
        .collection('MentorData/$uid/Mentees')
        .orderBy('FirstName')
        .snapshots()) {
      menteesList.clear();
      final mentees = snapshot.docs;
      for (var mentee in mentees) {
        await firestore
            .collection('/MenteeInfo')
            .doc(mentee.id)
            .get()
            .then((value) {
          String firstName = mentee.get('FirstName');
          String lastName = mentee.get('LastName');
          Mentee mnt = Mentee(
            uid: mentee.id,
            batchName: value['BatchName'],
            firstName: firstName,
            gender: value['Gender'],
            idNumber: value['IDNumber'],
            initialLevel: value['InitialLevel'],
            joiningDate: value['JoiningDate'].toDate(),
            lastName: lastName,
            latestLecture: value['LatestLecture'],
            organization: value['Organization'],
            phoneNumber: value['PhoneNumber'],
            fullName: "$firstName $lastName",
            totalEngagementLectures: 0,
            totalEngagementTime: Duration(minutes: 0),
          );
          menteesList.add(mnt);
        });
      }
      callback();
    }
  }

  DeclareCompletionData(VoidCallback callback) async {
    await for (var snapshot in firestore
        .collection('MentorData/$mentorUID/Schedule')
        .orderBy('LectureTime')
        .snapshots()) {
      for (Mentee mentee in menteesList) {
        mentee.totalEngagementLectures = 0;
        mentee.totalEngagementTime = Duration(minutes: 0);
      }
      final schedules = snapshot.docs;
      for (var schedule in schedules) {
        for (Mentee mentee in menteesList) {
          if (mentee.uid == schedule.get('MenteeUID')) {
            mentee.totalEngagementLectures++;
            mentee.totalEngagementTime +=
                Duration(minutes: schedule.get('Duration'));
          }
        }
      }
      callback();
    }
  }

  DropMentee(Mentee mentee) {
    firestore
        .collection('MentorData/$mentorUID/Mentees')
        .doc(mentee.uid)
        .delete();
  }
}

class MentorProfileData {
  final String batchName,
      firstName,
      lastName,
      organization,
      email,
      gender,
      qualification,
      specialization;
  final int idNumber, phoneNumber, age;
  final DateTime joiningDate;

  MentorProfileData(
      {required this.batchName,
      required this.firstName,
      required this.email,
      required this.gender,
      required this.joiningDate,
      required this.idNumber,
      required this.lastName,
      required this.organization,
      required this.phoneNumber,
      required this.age,
      required this.qualification,
      required this.specialization});
}

class MentorScheduleData {
  final Duration lastInteraction, nextInteraction;
  final double lecturesPerWeek, hoursPerWeek;

  MentorScheduleData(
      {required this.nextInteraction,
      required this.lastInteraction,
      required this.hoursPerWeek,
      required this.lecturesPerWeek});
}

class Schedule {
  String mentee, menteeUID, mentorScheduleID, menteeScheduleID, footNotes;
  DateTime timing;
  int duration, lesson;
  bool postSessionSurvey;
  Schedule({
    required this.menteeUID,
    required this.menteeScheduleID,
    required this.mentorScheduleID,
    required this.mentee,
    required this.lesson,
    required this.duration,
    required this.timing,
    required this.postSessionSurvey,
    required this.footNotes,
  });
}

class Mentee {
  String firstName,
      uid,
      lastName,
      batchName,
      fullName,
      initialLevel,
      gender,
      organization;
  int latestLecture, phoneNumber, idNumber, totalEngagementLectures;
  DateTime joiningDate;
  Duration totalEngagementTime;

  Mentee({
    required this.firstName,
    required this.batchName,
    required this.uid,
    required this.joiningDate,
    required this.lastName,
    required this.fullName,
    required this.initialLevel,
    required this.latestLecture,
    required this.gender,
    required this.organization,
    required this.idNumber,
    required this.phoneNumber,
    required this.totalEngagementLectures,
    required this.totalEngagementTime,
  });
}

class Response {
  int score;
  String answer, question;

  Response({required this.score, required this.answer, required this.question});
}

class Lesson {
  String title, duration, url;

  Lesson({required this.title, required this.duration, required this.url});
}
