import 'notificationEnum.dart';

class NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final String date;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.date,
    required this.type,
  });
  // Factory constructor to create a NotificationItem from JSON
 factory NotificationItem.fromJson(Map<String, dynamic> json) {
  return NotificationItem(
    title: json['title'] ?? '',  // Default to an empty string if 'title' is null
    subtitle: json['subtitle'] ?? '',  // Default to an empty string if 'subtitle' is null
    time: json['time'] ?? '',  // Default to an empty string if 'time' is null
    date: json['date'] ?? '',  // Default to an empty string if 'date' is null
    type: NotificationType.values.firstWhere(
      (e) => e.toString() == 'NotificationType.${json['type']}',
      orElse: () => NotificationType.system, // Default to system if 'type' is null or invalid
    ),
  );
}


  // Method to convert NotificationItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'date': date,
      'type': type.toString().split('.').last,
    };
  }
}
