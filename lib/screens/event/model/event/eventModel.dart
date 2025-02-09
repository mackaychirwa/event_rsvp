import 'package:hive_ce/hive.dart';

part 'eventModel.g.dart'; 

@HiveType(typeId: 3)
class EventModel {
  @HiveField(0)
  int localId;

  @HiveField(1)
  String id; 

  @HiveField(2)
  String eventName;

  @HiveField(3)
  String location;

  @HiveField(4)
  int attendee;

  EventModel({
    this.localId = 0,
    required this.id,
    required this.eventName,
    required this.location,
    required this.attendee,
  });

  // Convert Firestore document to EventModel object
  factory EventModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return EventModel(
      id: docId,
      eventName: data['event_name'] ?? '',
      location: data['location'] ?? '',
      attendee: data['attendee'] ?? 0,
    );
  }

  /// Convert EventModel object to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      "event_name": eventName,
      "location": location,
      "attendee": attendee,
    };
  }
factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['uid'] ?? '',
      eventName: map['eventName'] ?? '',
      location: map['location'] ?? '',
      attendee: map['attendee'] ?? 0,
    );
  }
}
