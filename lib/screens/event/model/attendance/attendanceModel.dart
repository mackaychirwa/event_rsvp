import 'package:hive_ce/hive.dart';

part 'attendanceModel.g.dart'; 

@HiveType(typeId: 2) 
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

  factory AttendanceModel.fromFirestore(Map<String, dynamic> data) {
    return AttendanceModel(
      uid: data['uid'] ?? '',
      eventId: data['event_id'] ?? '',
      attendance: data['attendance'] ?? 'attending',
      sync: 'done', 
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "event_id": eventId,
      "attendance": attendance,
    };
  }
}
