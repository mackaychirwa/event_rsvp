import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:event_rsvp/core/database/attendance/attendance.dart';
import 'package:event_rsvp/core/database/registration/userRegistrationDatabase.dart';

import '../event/event_cubit.dart';

abstract class AttendeeState extends Equatable {
  @override
  List<Object> get props => [];
}

class AttendeeInitial extends AttendeeState {}

class AttendeeLoading extends AttendeeState {}

class AttendeeLoaded extends AttendeeState {
  final int attendeeCount;
  AttendeeLoaded(this.attendeeCount);

  @override
  List<Object> get props => [attendeeCount];
}

class AttendeeError extends AttendeeState {
  final String error;
  AttendeeError(this.error);

  @override
  List<Object> get props => [error];
}
class AttendeeSuccess extends AttendeeState {
   final int attendeeCount;
  AttendeeSuccess(this.attendeeCount);

  @override
  List<Object> get props => [attendeeCount];
}
class AttendeeCubit extends Cubit<int> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AttendeeCubit() : super(0);

  
  Future<void> loadAttendeeCount(String eventId) async {
    try {
      DocumentSnapshot snapshot = await _firebaseFirestore.collection('events').doc(eventId).get();
      if (snapshot.exists) {
        emit(snapshot['attendee'] ?? 0);
      } else {
        emit(0);
      }
    } catch (e) {
      print("Error loading attendee count: $e");
      emit(0);
    }
  }

  // Method to increase the attendee count

  Future<void> increaseAttendeeCount(String eventId) async {
    try {
      await _firebaseFirestore.collection('events').doc(eventId).update({
        'attendee': FieldValue.increment(1),
      });

      await AttendanceDatabase().createAttendanceData(eventId);

      loadAttendeeCount(eventId);
    
    } catch (e) {
      print("Error updating attendee count: $e");
    }
  }

  
}
