import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      loadAttendeeCount(eventId);
    } catch (e) {
      print("Error updating attendee count: $e");
    }
  }
}
