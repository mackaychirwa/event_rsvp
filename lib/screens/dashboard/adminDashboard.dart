import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_rsvp/screens/event/model/event/eventModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constant/images.dart';
import '../event/bloc/event/event_cubit.dart';
import '../authentication/bloc/user/user_bloc.dart';
import '../event/eventPage.dart';
import 'package:flutter/material.dart';
import '../../widget/appBar/custom_app_bar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers for event inputs
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _attendeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EventCubit>().fetchEvents();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _attendeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(title: 'AdminDashboard'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventModal,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show modal
  void _showAddEventModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Event",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _eventNameController,
                decoration: const InputDecoration(labelText: "Event Name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _attendeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Attendee Count"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveEventToFirebase,
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to save event to Firebase
  Future<void> _saveEventToFirebase() async {
    final String eventName = _eventNameController.text.trim();
    final String location = _locationController.text.trim();
    final String attendee = _attendeeController.text.trim();

    if (eventName.isEmpty || location.isEmpty || attendee.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'event_name': eventName,
        'location': location,
        'attendee': int.parse(attendee),
      });

      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event added successfully!")),
      );

      context.read<EventCubit>().fetchEvents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Widget _buildBestForYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        const SizedBox(height: 12),
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventPage(event: event)),
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
          title: Text(event.eventName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(event.location),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${event.attendee}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
