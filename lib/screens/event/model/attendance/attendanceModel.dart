import 'package:hive_ce/hive.dart';

part 'attendanceModel.g.dart'; // Required for Hive type generation

@HiveType(typeId: 0) // Set the typeId for the model (must be unique within your app)
class AttendanceModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  String uid;

  @HiveField(2)
  String eventId;

  @HiveField(3)
  String attendance;

  @HiveField(4)
  String sync;

  AttendanceModel({
    this.id = 0,
    required this.uid,
    required this.eventId,
    this.attendance = 'attending',
    this.sync = 'none',
  });

  // Convert Firestore document to Attendance object
  factory AttendanceModel.fromFirestore(Map<String, dynamic> data) {
    return AttendanceModel(
      uid: data['uid'] ?? '',
      eventId: data['event_id'] ?? '',
      attendance: data['attendance'] ?? 'attending',
      sync: 'done', // Set sync as 'done' by default for firestore data
    );
  }

  /// Convert Attendance object to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "event_id": eventId,
      "attendance": attendance,
    };
  }
}
