import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelRsvpDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const CancelRsvpDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cancel RSVP"),
      content: const Text("Are you sure you want to cancel your RSVP for this event?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Get.back();
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
