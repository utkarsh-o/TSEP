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
    await getMenteeData(callback);
  }

  getCurrentUser() async {
    try {
      final User user = await auth.getCurrentUser();
      uid = user.uid;
      mentorUID = uid;
    } catch (error) {
      print('MentorProfile error -> $error');
    }
  }

  getMentorProfileData(VoidCallback callback) async {
    await for (var snapshot
        in firestore.collection('MentorData').doc(uid).snapshots()) {
      mentorProfileData = MentorProfileData(
        batchName: snapshot.get('BatchName').toString(),
        firstName: snapshot.get('FirstName').toString(),
        idNumber: snapshot.get('IDNumber'),
        lastName: snapshot.get('LastName').toString(),
        organization: snapshot.get('Organization').toString(),
        email: snapshot.get('email'),
        joiningDate: snapshot.get('JoiningDate').toDate(),
        gender: snapshot.get('Gender'),
      );
      joiningDate = snapshot.get('JoiningDate').toDate();
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
          );
          menteesList.add(mnt);
        });
      }
      callback();
    }
  }
}

class MentorProfileData {
  final String batchName, firstName, lastName, organization, email, gender;
  final int idNumber;
  final DateTime joiningDate;
  MentorProfileData({
    required this.batchName,
    required this.firstName,
    required this.email,
    required this.gender,
    required this.joiningDate,
    required this.idNumber,
    required this.lastName,
    required this.organization,
  });
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
  String mentee, menteeUID, mentorScheduleID, menteeScheduleID;
  DateTime timing;
  int duration, lesson;

  Schedule({
    required this.menteeUID,
    required this.menteeScheduleID,
    required this.mentorScheduleID,
    required this.mentee,
    required this.lesson,
    required this.duration,
    required this.timing,
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
  int latestLecture, phoneNumber, idNumber;
  DateTime joiningDate;
  Mentee(
      {required this.firstName,
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
      required this.phoneNumber});
}

class Response {
  int score;
  String answer, question;
  Response({required this.score, required this.answer, required this.question});
}

class Lesson {
  String title, duration;
  Lesson({required this.title, required this.duration});
}
