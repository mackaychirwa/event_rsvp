import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/dialogs/dialog.dart';
import 'eventPage.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _recentReads = [
    {
      'title': 'The Silent Patient',
      'progress': 0.65,
      'author': 'Alex Michaelides'
    },
    {'title': 'Atomic Habits', 'progress': 0.85, 'author': 'James Clear'},
    {'title': '1984', 'progress': 0.45, 'author': 'George Orwell'},
    {'title': 'Dune', 'progress': 0.25, 'author': 'Frank Herbert'},
  ];

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
        
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildBestForYouCard("Artexpo | Visual Design Exhibition", "Dec 22-31", "Jogja Expo Center", "\5"),
            _buildBestForYouCard("Classic Vespa Festival 2021 - Bali", "Dec 29-30", "Western Park", "\10"),
          ],
        ),
      ],
    );
  }

Widget _buildBestForYouCard(String title, String date, String location, String attendeeCount) {
  return GestureDetector(
  onTap: () =>   Get.dialog(CancelRsvpDialog(
    onConfirm: () {
      // Handle cancellation logic here
      print("RSVP Cancelled");
    },
  ),),
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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$date | $location"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              attendeeCount,
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
