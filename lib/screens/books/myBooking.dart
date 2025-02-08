import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/bloc/event/event_cubit.dart';
import '../../core/bloc/user/user_bloc.dart';
import '../../models/event/eventModel.dart';
import '../../widget/dialogs/dialog.dart';
import 'eventPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<UserCubit>().fetchUser();
    context.read<EventCubit>().fetchMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Bookings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18, // Slightly bigger for visibility
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0.0,
        actions: [
          Transform.translate(
            offset: const Offset(-10, 0), // Moves left by 10 pixels
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black,
              child: IconButton(
                icon: const Icon(Icons.person, size: 15, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBestForYouSection(),
      ),
      // endDrawer: const CustomDrawer(),
    );
  }
    Widget _buildBestForYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<EventCubit, EventState>(
          builder: (context, state) {
            if (state is EventLoaded) {

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return _buildBestForYouCard(event);
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
  Widget _buildBestForYouCard(EventModel event) {
    return InkWell(
      onTap: () =>   Get.dialog(CancelRsvpDialog(
        onConfirm: () {
          // Handle cancellation logic here
          print("RSVP Cancelled");
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
          title: Text(event.event_name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(event.location),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${event.attendee}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
}

