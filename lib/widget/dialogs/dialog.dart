import 'package:flutter/material.dart';

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
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();  
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
