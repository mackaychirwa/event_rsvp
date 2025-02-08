import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';
import '../../model/event/eventModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/network/internet_connectivity.dart';

// Define the events states
abstract class EventState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoaded extends EventState {
  final List<EventModel> events;
  // final List<Map<String, dynamic>> events;
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
  EventCubit() : super(EventInitial());
  final user = FirebaseAuth.instance.currentUser;
  late Box<EventModel> getEvent;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> fetchEvents() async {
    try {
      QuerySnapshot snapshot =
          await _firebaseFirestore.collection('events').get();

      final events = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final event = EventModel.fromFirestore(data, doc.id);
        log(event as String);
        // getEvent.put(doc.id, event);
        return EventModel.fromFirestore(data, doc.id);
      }).toList();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> fetchMyEvents() async {
    try {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('events').doc(user!.uid).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final event = EventModel.fromFirestore(data, snapshot.id);

        emit(EventLoaded([event]));
      } else {
        emit(EventLoaded([]));
      }
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
