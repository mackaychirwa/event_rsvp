import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widget/Nodata/noData.dart';
import 'bloc/notification/notification_cubit.dart';
import 'model/notification/notificationEnum.dart';
import 'model/notification/notificationItem.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final String userUid;

  @override
  void initState() {
    super.initState();
    userUid =
        FirebaseAuth.instance.currentUser?.uid ?? ''; // Get current user UID
    if (userUid.isNotEmpty) {
      // Fetch notifications for the user when the page is initialized
      context.read<AttendanceNotificationCubit>().fetchNotification();
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
              // Handle notifications clearing if needed
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body:
          BlocBuilder<AttendanceNotificationCubit, AttendanceNotificationState>(
        builder: (context, state) {
          if (state is AttendanceNotificationLoading) {
            return const NoData(message: 'No Notifications');
          }

          if (state is AttendanceNotificationError) {
            return Center(child: Text(state.error));
          }

          if (state is AttendanceNotificationLoaded) {
            final notifications = state.notifications;

            return notifications.isEmpty
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
                          // Handle item dismissal if needed
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
                                // Handle tap on the notification
                              },
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  );
          }

          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
