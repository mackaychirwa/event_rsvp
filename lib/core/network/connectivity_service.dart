import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce/hive.dart';

import '../global_bloc/sync/sync_cubit.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  void startConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        syncToFirestore();
      }
    });
  }
  
  Future<void> syncToFirestore() async {
    var box = await Hive.openBox('attendanceBox');

    for (var key in box.keys) {
      Map<String, dynamic> data = Map<String, dynamic>.from(box.get(key));

      if (data['sync'] == 'none') {
        try {
          await _firestore.collection("user_attendance").doc(user!.uid).set({
            'uid': data['uid'],
            'events': FieldValue.arrayUnion([data['event_id']]),
            'attendance': 'attending',
          }, SetOptions(merge: true));

          // Update sync status in local storage
          data['sync'] = 'done';
          await box.put(key, data);

          // Emit sync done and send notification
          SyncCubit().syncDone();
         
        } catch (e) {
          print("Sync failed: $e");
        }
      }
    }
  }
}
