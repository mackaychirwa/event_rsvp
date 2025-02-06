import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static const String titleOne = 'Title 1';
  static const String titleTwo = 'Title 2';
  static const String titleThree = 'Title 3';
  static const String titleFour = 'Title 4';

  static const String descriptionOne = 'Description 1';
  static const String descriptionTwo = 'Description 2';
  static const String descriptionThree = 'Description 3';
  static const String descriptionFour = 'Description 4';

  static const Color primaryColor = Colors.blue;

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
