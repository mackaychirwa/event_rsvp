import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';
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

// Create the Cubit to manage the event state
class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial()) {
    _openBox();
  }
  final user = FirebaseAuth.instance.currentUser;
  late Box<EventModel> getEvent;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // Open the Hive box
  Future<void> _openBox() async {
    getEvent = await Hive.openBox<EventModel>('eventsBox');
  }

  Future<void> fetchEvents() async {
    try {
      QuerySnapshot snapshot =
          await _firebaseFirestore.collection('events').get();

      final events = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final event = EventModel.fromFirestore(data, doc.id);
        log(event.toString());
        getEvent.put(doc.id, event);
        return event;
      }).toList();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> fetchMyEvents() async {
    try {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('user_attendance').doc(user!.uid).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final event = EventModel.fromFirestore(data, snapshot.id);
        print('Event' + event.toString());

        emit(EventLoaded([event]));
      } else {
        print('esles');
        emit(EventLoaded([]));
      }
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
