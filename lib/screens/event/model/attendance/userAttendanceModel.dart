class UserAttendanceModel {
  final String attending;
  final String eventId;
  final List<String> events;
  final String uid;

  UserAttendanceModel({
    required this.attending,
    required this.eventId,
    required this.events,
    required this.uid,
  });

  // From Firestore document to model object
  factory UserAttendanceModel.fromFirestore(Map<String, dynamic> data) {
    return UserAttendanceModel(
      attending: data['attending'] ?? '',
      eventId: data['event_id'] ?? '',
      events: List<String>.from(data['events'] ?? []),
      uid: data['uid'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserAttendanceModel(attending: $attending, eventId: $eventId, events: $events, uid: $uid)';
  }
}
