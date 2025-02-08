import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widget/Nodata/noData.dart';
import 'model/notification/notificationEnum.dart';
import 'model/notification/notificationItem.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    generateRSVPNotifications(); 
  }

  void generateRSVPNotifications() {
    final random = Random();
    final List<String> titles = [
      'RSVP Confirmation',
      'Event Reminder',
      'RSVP Cancellation',
      'Event Update',
      'Event RSVP Closed',
      'Upcoming Event Alert',
      'RSVP Deadline Approaching',
    ];

    final List<String> subtitles = [
      'Your RSVP for the event has been confirmed.',
      'Reminder: The event you RSVP for is coming up soon.',
      'Your RSVP for the event has been canceled.',
      'There has been an update to the event details.',
      'RSVP for this event is now closed.',
      'An event you might be interested in is happening soon.',
      'The RSVP deadline for an event is approaching.',
    ];

    final List<NotificationType> types = [
      NotificationType.person,
      NotificationType.system,
    ];

    for (int i = 0; i < 7; i++) {
      notifications.add(
        NotificationItem(
          title: titles[random.nextInt(titles.length)],
          subtitle: subtitles[random.nextInt(subtitles.length)],
          time:
              '${random.nextInt(12) + 1}:${random.nextInt(60).toString().padLeft(2, '0')} ${random.nextBool() ? 'AM' : 'PM'}',
          date: 'July ${random.nextInt(30) + 1}, 2025',
          type: types[random.nextInt(types.length)],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                notifications.clear();
              });
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: notifications.isEmpty
          ? const NoData(message: 'No Notifications')
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification.hashCode.toString()),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerStart,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      notifications.removeAt(index);
                    });
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            notification.type == NotificationType.person
                                ? FontAwesomeIcons.user
                                : FontAwesomeIcons.bell,
                            size: 24,
                          ),
                        ),
                        title: Text(notification.title),
                        subtitle: Text(notification.subtitle),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(notification.time),
                            Text(notification.date),
                          ],
                        ),
                        onTap: () {
                          if (notification.type == NotificationType.person) {
                          } else {
                          }
                        },
                      ),
                      const Divider(), 
                    ],
                  ),
                );
              },
            ),
    );
  }
}
