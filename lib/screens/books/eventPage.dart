import 'package:event_rsvp/models/event/eventModel.dart';
import 'package:event_rsvp/widget/appBar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constant/images.dart';
import '../../constant/colors.dart';
import '../../constant/sizes.dart';
import '../../core/bloc/attendance/attendance_cubit.dart';

class EventPage extends StatelessWidget {
  final EventModel event;
  const EventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Event Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                TImages.user, 
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: CSizes.spaceBtwSections),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Going On',
                      style: TextStyle(color: CColors.white)),
                ),
                const Spacer(),
             
              ],
            ),
            Text(
              event.event_name, 
              style: const TextStyle(
                  color: CColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.group, color: CColors.black, size: 16),
                const SizedBox(width: 5),
                Text(
                  event.event_name,
                  style: const TextStyle(color: CColors.black),
                ),
              ],
            ),
            const SizedBox(height: CSizes.spaceBtwSections),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Location Details',
                            style: TextStyle(color: CColors.white)),
                      ),
                    ],
                  ),
                    eventDetailItem(
                    Icons.calendar_today,
                    "2","",
                  ),
                  const SizedBox(height: 10),
                  eventDetailItem(Icons.location_on, event.location,
                      event.location),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                  context.read<AttendeeCubit>().increaseAttendeeCount(event.id);
                  Navigator.pushReplacementNamed(context, '/bottomNav');

              }, 
              child: const Text('RSVP', style: TextStyle(color: CColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventDetailItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: CColors.white),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: CColors.black, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ],
    );
  }
}
