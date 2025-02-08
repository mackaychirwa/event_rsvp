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
}
