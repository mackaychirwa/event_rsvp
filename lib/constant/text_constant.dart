import 'package:flutter/material.dart';
import 'dart:ui';
import 'colors.dart';

class TextConstants {
  static const String titleOne = 'Seamless Event Planning';
  static const String titleTwo = 'Instant RSVP Tracking';
  static const String titleThree = 'Offline Access';
  static const String titleFour = 'Personalized Notifications';
  static const String titleSystem = 'Event RSVP';

  static const String descriptionOne =
      "Effortlessly organize and manage events with an intuitive interface. Send invitations, track attendees, and stay in control of every detail.";

  static const String descriptionTwo =
      "Keep track of RSVPs in real-time. See who has confirmed, pending responses, and send reminders to ensure maximum attendance.";

  static const String descriptionThree =
      "Access and manage event details even without an internet connection. Our offline mode ensures you never lose critical event information.";

  static const String descriptionFour =
      "Send automatic reminders, updates, and thank-you messages to guests. Keep everyone informed with scheduled notifications via email or SMS.";

  static Color primaryColor = CColors.primaryColor;

 
  static String getTitle(int index) {
    switch (index) {
      case 0:
        return titleOne;
      case 1:
        return titleTwo;
      case 2:
        return titleThree;
      case 3:
        return titleFour;
      default:
        return '';
    }
  }

  static String getDescription(int index) {
    switch (index) {
      case 0:
        return descriptionOne;
      case 1:
        return descriptionTwo;
      case 2:
        return descriptionThree;
      case 3:
        return descriptionFour;
      default:
        return '';
    }
  }

}
