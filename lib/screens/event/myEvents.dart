import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_rsvp/helpers/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/appBar/custom_app_bar.dart';
import 'bloc/event/event_cubit.dart';
// import 'model/event/eventModel.dart';
import 'model/attendance/attendanceModel.dart';
import '../../widget/dialogs/dialog.dart';
import 'model/event/eventModel.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<EventCubit>().fetchMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(title: 'My Events'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildBestForYouSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBestForYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<EventCubit, EventState>(
          builder: (context, state) {
            if (state is EventLoaded) {
              if (state.events.isEmpty) {
                return const Center(child: Text('You have no active events'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return _buildBestForYouCard(event);
                },
              );
            } else if (state is EventError) {
              return const Center(child: Text('You have no active events'));
            } else {
              return const Center(child: Text('You have no active events'));
            }
          },
        ),
      ],
    );
  }

  Widget _buildBestForYouCard(EventModel event) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => CancelRsvpDialog(
          onConfirm: () {
            context.read<EventCubit>().cancelRSVP(event.id);
            CHelperFunctions.showSnackBar(
                context, "Your RSVP has been cancelled");
          },
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            child: const Icon(Icons.event, size: 30, color: Colors.grey),
          ),
          title: Text(
            event.eventName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(event.location),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${event.attendee}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                "Attendees",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildBestForYouCard(EventModel event) {
  //   return InkWell(
  //     onTap: () => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CancelRsvpDialog(
  //           onConfirm: () async {
  //             print("RSVP Cancelled for event: ${event.eventName}");

  //             try {
  //               final user = FirebaseAuth.instance.currentUser;
  //               if (user == null) return;

  //               final userRef = FirebaseFirestore.instance
  //                   .collection("user_attendance")
  //                   .doc(user.uid);

  //               final eventRef = FirebaseFirestore.instance
  //                   .collection("events")
  //                   .doc(event.id);

  //               // Get user attendance data
  //               final snapshot = await userRef.get();
  //               if (snapshot.exists) {
  //                 List<dynamic> eventData = snapshot.data()?['events'] ?? [];
  //                 eventData
  //                     .removeWhere((e) => e.toString() == event.id.toString());
  //                 print("RSVP eventData: ${eventData}");

  //                 // Update user attendance
  //                 await userRef.update({'events': eventData});

  //                 // Decrease event attendee count
  //                 await FirebaseFirestore.instance
  //                     .runTransaction((transaction) async {
  //                   final eventSnapshot = await transaction.get(eventRef);
  //                   if (eventSnapshot.exists) {
  //                     int currentAttendees =
  //                         eventSnapshot.data()?['attendee'] ?? 0;
  //                     print('eventSnapshot' + currentAttendees.toString());

  //                     int newAttendeeCount =
  //                         (currentAttendees > 0) ? currentAttendees - 1 : 0;
  //                     transaction
  //                         .update(eventRef, {'attendee': newAttendeeCount});
  //                   }
  //                 });

  //                 if (mounted) {
  //                   context.read<EventCubit>().fetchMyEvents();
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                         content: Text("Your RSVP has been cancelled")),
  //                   );
  //                 }
  //               }
  //             } catch (e) {
  //               print("Error cancelling RSVP: $e");
  //             }
  //           },
  //         ),
  //       ),
  //     ),
  //     child: Card(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       child: ListTile(
  //         leading: Container(
  //           width: 60,
  //           height: 60,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8),
  //             color: Colors.grey.shade300,
  //           ),
  //           child: const Icon(Icons.event, size: 30, color: Colors.grey),
  //         ),
  //         title: Text(
  //           event.eventName,
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         subtitle: Text(event.location),
  //         trailing: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               "${event.attendee}",
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 16,
  //               ),
  //             ),
  //             const Text(
  //               "Attendees",
  //               style: TextStyle(fontSize: 12, color: Colors.grey),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
