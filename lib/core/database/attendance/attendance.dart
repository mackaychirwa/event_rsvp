import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceDatabase {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  final CollectionReference attendance = FirebaseFirestore.instance.collection("user_attendance");
  Future<void> createAttendanceData(String event_ID) async {
    return await attendance.doc(user!.uid).set({
      'uid': user!.uid,
      'event_id': event_ID,
      'attendance': 'attending',
    });
  }
}


