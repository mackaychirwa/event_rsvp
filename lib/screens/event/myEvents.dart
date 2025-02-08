import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/appBar/custom_app_bar.dart';
import 'bloc/event/event_cubit.dart';
import 'model/event/eventModel.dart';
import '../../widget/dialogs/dialog.dart';

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
Widget _buildWelcomeMessage(String username) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, $username!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "What would you like to explore today?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
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
              print(state.events);
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
              return Center(
                child: Text('Error: ${state.error}'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
Widget _buildBestForYouCard(EventModel event) {
  return InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CancelRsvpDialog(
          onConfirm: () async {
            // Handle cancellation logic here
            print("RSVP Cancelled for event: ${event.eventName}");

            try {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final userRef = FirebaseFirestore.instance.collection("user_attendance").doc(user.uid);

              // Get the current events list
              final snapshot = await userRef.get();
              if (snapshot.exists) {
                List<dynamic> eventData = snapshot.data()?['events'] ?? [];

                // Remove the event from the list
                eventData.removeWhere((e) => e['id'] == event.id);

                // Update Firestore with the modified list
                await userRef.update({
                  'events': eventData,
                });

                // Optionally, update the UI after the event is canceled
                context.read<EventCubit>().fetchMyEvents();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Your RSVP has been cancelled")),
                );
              }
            } catch (e) {
              print("Error cancelling RSVP: $e");
            }
          },
        ),
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
  //           onConfirm: () {
  //             // Handle cancellation logic here
  //             print("RSVP Cancelled");
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