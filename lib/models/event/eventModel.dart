class EventModel {
  final String id;
  final String event_name;
  final String event_date;
  final String location;
  final int attendee; 

  EventModel({
    required this.id,
    required this.event_name,
    required this.event_date,
    required this.location,
    required this.attendee,
  });

  factory EventModel.fromFirestore(Map<String, dynamic> data) {
    return EventModel(
      id: data['id'] ?? '',
      event_name: data['event_name'] ?? '',
      event_date: data['event_date'] ?? '',
      location: data['location'] ?? '',
      attendee: data['attendee'] ?? 0,  
    );
  }
}
