import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/global_bloc/sync/sync_cubit.dart';
import '../../../authentication/model/user/userModel.dart';
import '../../model/attendance/userAttendanceModel.dart';
import '../../model/event/eventModel.dart';

class AttendanceDatabase {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late Box<EventModel> getEvent;

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
      attendanceNotification(eventID, 'You are attending the event', 'Event Attendance');
    } catch (e) {
      print("Firestore attendance save failed: $e");
    }
  }
 Future<void> attendanceNotification(String eventID, String status, String subtitle) async {
  try {
        // Get the current date and time
        final now = DateTime.now();
        final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
        final date = '${now.month}/${now.day}/${now.year}';
        
        
        // Store the notification in Firestore
        await _firestore.collection("notifications").doc(user!.uid).set({
          'uid': user!.uid,
          'events': FieldValue.arrayUnion([eventID]),
          'title': status,
          'subtitle': subtitle,
          'time': time,
          'date': date,
          'type': 'system', 
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

          // Emit sync done and send notification sync function from local to firebase
          SyncCubit().syncDone();
        } catch (e) {
          print("Sync failed: $e");
        }
      }
    }
  }

  Future<void> cancelRSVP(String eventId) async {
    try {
      if (user == null) return;

      final userRef = _firestore.collection("user_attendance").doc(user!.uid);
      final eventRef = _firestore.collection("events").doc(eventId);

      final snapshot = await userRef.get();
      if (snapshot.exists) {
        List<dynamic> eventData = snapshot.data()?['events'] ?? [];
        eventData.removeWhere((e) => e.toString() == eventId);

        // Update user's attendance list
        await userRef.update({'events': eventData});

        // Decrease event attendee count
        await _firestore.runTransaction((transaction) async {
          final eventSnapshot = await transaction.get(eventRef);
          if (eventSnapshot.exists) {
            int currentAttendees = eventSnapshot.data()?['attendee'] ?? 0;
            int newAttendeeCount =
                (currentAttendees > 0) ? currentAttendees - 1 : 0;
            transaction.update(eventRef, {'attendee': newAttendeeCount});
          }
        });
      attendanceNotification(eventId, 'You have cancelled this event', 'cancelled');

      }
    } catch (e) {
      throw Exception("Error cancelling RSVP: $e");
    }
  }

  // Retrieves events for a specific user
  Future<List<EventModel>> getUserEvents(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('user_attendance')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final userAttendance = UserAttendanceModel.fromFirestore(data);

        List<EventModel> events = [];
        for (String eventId in userAttendance.events) {
          DocumentSnapshot eventSnapshot = await _firestore
              .collection('events')
              .doc(eventId)
              .get();
          if (eventSnapshot.exists) {
            final eventData = eventSnapshot.data() as Map<String, dynamic>;
            final event = EventModel.fromFirestore(eventData, eventSnapshot.id);
            events.add(event);
          }
        }
        return events;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching user events: $e');
    }
  }
  Future<List<EventModel>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();

      final events = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final event = EventModel.fromFirestore(data, doc.id);
        return event;
      }).toList();

      return events;
    } catch (e) {
      print('Error fetching events from Firestore: $e');
      return [];  
    }
  }
  
  Future<void> logout() async {
      var userBox = await Hive.openBox<UserModel>('userBox');
      await userBox.clear();  
      await userBox.close();
      await FirebaseAuth.instance.signOut();
  }
}
