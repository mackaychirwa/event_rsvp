import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/global_bloc/sync/sync_cubit.dart';

class AttendanceDatabase {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

   Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'attendance_channel',
      'Attendance Sync',
      channelDescription: 'Sync notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  /// Save attendance to Firestore
  Future<void> createAttendanceData(String eventID) async {
    try {
      await _firestore.collection("user_attendance").doc(user!.uid).set({
        'uid': user!.uid,
        'events': FieldValue.arrayUnion([eventID]),
        'attendance': 'attending',
      }, SetOptions(merge: true));
    } catch (e) {
      print("Firestore attendance save failed: $e");
    }
  }

  /// Save to local storage using Hive (for offline use)
  Future<void> saveToLocalStorage(String eventID) async {
    var box = await Hive.openBox('attendanceBox');

    Map<String, dynamic> attendanceData = {
      'uid': user!.uid,
      'event_id': eventID,
      'attendance': 'attending',
      'sync': 'none',
    };

    await box.put(eventID, attendanceData);
  }

  /// Sync local attendance data to Firestore
  Future<void> syncToFirestore() async {
    var box = await Hive.openBox('attendanceBox');

    for (var key in box.keys) {
      Map<String, dynamic> data = Map<String, dynamic>.from(box.get(key));

      if (data['sync'] == 'none') {
        try {
          await _firestore.collection("user_attendance").doc(user!.uid).set({
            'uid': data['uid'],
            'events': FieldValue.arrayUnion([data['event_id']]),
            'attendance': 'attending',
          }, SetOptions(merge: true));

          // Update sync status in local storage
          data['sync'] = 'done';
          await box.put(key, data);

          // Emit sync done and send notification
          SyncCubit().syncDone();
      
        } catch (e) {
          print("Sync failed: $e");
        }
      }
    }
  }
}
