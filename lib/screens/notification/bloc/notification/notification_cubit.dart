import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_rsvp/screens/notification/database/notification/notificationDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../event/database/attendance/attendance.dart';
import '../../model/notification/notificationItem.dart';

// Define the events
abstract class AttendanceNotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AttendanceNotificationInitial extends AttendanceNotificationState {}

class AttendanceNotificationLoading extends AttendanceNotificationState {}

class AttendanceNotificationLoaded extends AttendanceNotificationState {
  final List<NotificationItem> notifications;
  AttendanceNotificationLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class AttendanceNotificationSuccess extends AttendanceNotificationState {
  final String eventID;
  final String status;

  AttendanceNotificationSuccess(this.eventID, this.status);

  @override
  List<Object> get props => [eventID, status];
}

class AttendanceNotificationError extends AttendanceNotificationState {
  final String error;

  AttendanceNotificationError(this.error);

  @override
  List<Object> get props => [error];
}

// Define the Cubit
class AttendanceNotificationCubit extends Cubit<AttendanceNotificationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NotificationDatabase notificationDatabase;

  AttendanceNotificationCubit(this.notificationDatabase) : super(AttendanceNotificationInitial());
  // _openBox();

  final user = FirebaseAuth.instance.currentUser;
  // late Box<EventModel> getEvent;

  // // Open the Hive box
  // Future<void> _openBox() async {
  //   getEvent = await Hive.openBox<EventModel>('eventsBox');
  // }

  // Method to send attendance notification
  Future<void> attendanceNotification(String eventID, String status) async {
    try {
      // Emit loading state
      emit(AttendanceNotificationLoading());

      // Ensure user is authenticated
      if (user == null) {
        emit(AttendanceNotificationError("User not authenticated"));
        return;
      }

      // Save attendance notification to Firestore
      await _firestore.collection("notifications").doc(user!.uid).set({
        'uid': user!.uid,
        'events': FieldValue.arrayUnion([eventID]),
        'attendance': status,
      }, SetOptions(merge: true));

      // Emit success state
      emit(AttendanceNotificationSuccess(eventID, status));
    } catch (e) {
      // Emit error state on failure
      emit(AttendanceNotificationError("Firestore attendance save failed: $e"));
    }
  }
   Future<void> fetchNotification() async {
    try {
      final notification = await notificationDatabase.getAllNotifications();
      
      emit(AttendanceNotificationLoaded(notification));
    } catch (e) {
      emit(AttendanceNotificationError(e.toString()));
    }
  }
}
