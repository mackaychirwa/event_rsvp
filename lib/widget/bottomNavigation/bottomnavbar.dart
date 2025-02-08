import 'package:flutter/material.dart';
import 'dart:ui';

import '../../screens/event/myEvents.dart';
import '../../screens/dashboard/dashboard.dart';
import '../../screens/notification/notification.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  final List _screens = [
    const Dashboard(),
    const Attendance(),
    const NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
 
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.black.withOpacity(0.8),
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  unselectedItemColor: Colors.white,
                  selectedFontSize: 12.0,
                  unselectedFontSize: 10.0,
                  currentIndex: selectedIndex,
                  onTap: (index) => setState(() {
                    selectedIndex = index;
                  }),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      label: 'Bookings',
                    ),
                  
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: 'Notifications',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
