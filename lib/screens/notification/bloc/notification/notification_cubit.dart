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
  NotificationDatabase notificationDatabase;

  AttendanceNotificationCubit(this.notificationDatabase) : super(AttendanceNotificationInitial());


   Future<void> fetchNotification() async {
    try {
      final notification = await notificationDatabase.getAllNotifications();
      
      emit(AttendanceNotificationLoaded(notification));
    } catch (e) {
      emit(AttendanceNotificationError(e.toString()));
    }
  }
}
