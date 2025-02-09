import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_rsvp/screens/notification/model/notification/notificationItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/global_bloc/sync/sync_cubit.dart';

class NotificationDatabase {
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


   Future<List<NotificationItem>> getAllNotifications() async {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('notifications').get();

        // Map each document to a NotificationItem object
        final events = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final event = NotificationItem.fromJson(data);
          return event;
        }).toList();

        return events;
      } catch (e) {
        print('Error fetching events from Firestore: $e');
        return [];  
      }
    }




}
