import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../core/bloc/online_offline/online_offline_cubit.dart';



class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Edit Details'),
            leading: const Icon(Icons.edit),
            onTap: () {
              // Navigate to edit details screen or show edit dialog
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Edit Details'),
                  content: const Text('Implement your edit details UI here'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Save edited details logic
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Details saved')),
                        );
                      },
                      child: const Text('SAVE'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Legal Information'),
            leading: const Icon(Icons.gavel),
            onTap: () {
              // Navigate to legal information screen
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Help'),
            leading: const Icon(Icons.help),
            onTap: () {
              // Navigate to help screen
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Version'),
            leading: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Sphere',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Event Sphere',
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Clear Cache'),
            leading: const Icon(Icons.cached),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content: const Text('Are you sure you want to clear the cache?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Clear cache logic
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cache cleared')),
                        );
                      },
                      child: const Text('CLEAR'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

         BlocBuilder<OnlineOfflineCubit, OnlineOfflineState>(
            builder: (context, state) {
              bool isOnline = state is OnlineState;

              return ListTile(
                title: const Text('Online Mode'),
                leading: const Icon(Icons.wifi),
                trailing: Switch(
                  value: isOnline,
                  onChanged: (bool value) {
                    // Toggle the online/offline mode using the cubit
                    context.read<OnlineOfflineCubit>().toggleOnlineStatus(value);

                    // Optionally, show a snack bar or perform any other action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value ? 'Switched to Online Mode' : 'Switched to Offline Mode',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () {
              Navigator.pushNamed(context, '/signin');

            },
          ),
          const Divider(),
            
        ],
      ),
    );
  }
}
