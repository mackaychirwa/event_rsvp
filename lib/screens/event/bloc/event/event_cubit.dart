import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';
import '../../database/attendance/attendance.dart';
import '../../model/attendance/userAttendanceModel.dart';
import '../../model/event/eventModel.dart';

// Define the events states
abstract class EventState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoaded extends EventState {
  final List<EventModel> events;
  EventLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EventError extends EventState {
  final String error;

  EventError(this.error);

  @override
  List<Object> get props => [error];
}

// Define the events
abstract class EventEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchEvents extends EventEvent {}
class EventRSVPCancelled extends EventState {}
// Create the Cubit to manage the event state
class EventCubit extends Cubit<EventState> {
  AttendanceDatabase attendanceDatabase;

  EventCubit(this.attendanceDatabase) : super(EventInitial()) {
    _openBox();
  }

  final user = FirebaseAuth.instance.currentUser;
  late Box<EventModel> getEvent;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Open the Hive box
  Future<void> _openBox() async {
    getEvent = await Hive.openBox<EventModel>('eventsBox');
  }

   Future<void> fetchEvents() async {
    try {
      final events = await attendanceDatabase.getAllEvents();
      for (var event in events) {
        getEvent.put(event.id, event);
      }
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  // Future<void> fetchMyEvents() async {
  //   try {
  //     if (user == null) {
  //       emit(EventError("User not authenticated"));
  //       return;
  //     }
  //     final events = await attendanceDatabase.getUserEvents(user!.uid);
  //     emit(EventLoaded(events));
  //   } catch (e) {
  //     emit(EventError(e.toString()));
  //   }
  // }

  Future<void> fetchMyEvents() async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('user_attendance')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final userAttendance = UserAttendanceModel.fromFirestore(data);

        // Fetch actual events based on event IDs
        List<EventModel> events = [];
        for (String eventId in userAttendance.events) {
          DocumentSnapshot eventSnapshot =
              await _firestore.collection('events').doc(eventId).get();
          if (eventSnapshot.exists) {
            final eventData = eventSnapshot.data() as Map<String, dynamic>;
            final event = EventModel.fromFirestore(eventData, eventSnapshot.id);
            events.add(event);
          }
        }

        print('Fetched Events: $events');
        emit(EventLoaded(events));
      } else {
        print('No events found for user');
        emit(EventLoaded([]));
      }
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> cancelRSVP(String eventId) async {
    try {
      await attendanceDatabase.cancelRSVP(eventId);
      emit(EventRSVPCancelled());
    } catch (e) {
      emit(EventError("Failed to cancel RSVP: $e"));
    }
  }
}
