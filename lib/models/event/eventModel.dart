class EventModel {
  final String id; // Add this
  final String event_name;
  final String location;
  final int attendee;

  EventModel({
    required this.id,
    required this.event_name,
    required this.location,
    required this.attendee,
  });

  factory EventModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return EventModel(
      id: docId, 
      event_name: data['event_name'] ?? '',
      location: data['location'] ?? '',
      attendee: data['attendee'] ?? 0,
    );
  }
}
