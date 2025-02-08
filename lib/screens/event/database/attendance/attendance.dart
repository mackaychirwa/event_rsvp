import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/global_bloc/sync/sync_cubit.dart';

class AttendanceDatabase {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;


  
  final CollectionReference attendance =
      FirebaseFirestore.instance.collection("user_attendance");

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initializes notifications
  Future<void> initializeNotifications() async {
    const android = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> createAttendanceData(String event_ID) async {
    return await attendance.doc(user!.uid).set({
      'uid': user!.uid,
      'event_id': event_ID,
      'attendance': 'attending',
    });
  }

  // save to local storage using hive
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

  /// Syncs local attendance data to Firestore
  Future<void> syncToFirestore() async {
    var box = await Hive.openBox('attendanceBox');

    for (var key in box.keys) {
      Map<String, dynamic> data = Map<String, dynamic>.from(box.get(key));

      if (data['sync'] == 'none') {
        try {
          await attendance.doc(user!.uid).set({
            'uid': data['uid'],
            'event_id': data['event_id'],
            'attendance': 'attending',
          });

          // Update sync status in local storage
          data['sync'] = 'done';
          await box.put(key, data);
          // Emit sync done and send notification
          SyncCubit().syncDone();
          _showNotification(
              "Sync Successful", "Your attendance data is synced!");
        } catch (e) {
          print("Sync failed: $e");
        }
      }
    }
  }

  // Function to show notification
  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'attendance_channel',
      'Attendance Sync',
      channelDescription: 'Channel for attendance sync notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }
}
