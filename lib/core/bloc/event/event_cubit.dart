import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/event/eventModel.dart';

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
  EventCubit() : super(EventInitial());

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<void> fetchEvents() async {
  try {
    QuerySnapshot snapshot = await _firebaseFirestore.collection('events').get();

    final events = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return EventModel.fromFirestore(data, doc.id); 
    }).toList();

    emit(EventLoaded(events));
  } catch (e) {
    emit(EventError(e.toString()));
  }
}


}
