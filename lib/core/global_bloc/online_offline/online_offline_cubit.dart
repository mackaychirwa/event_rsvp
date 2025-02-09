import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_rsvp/core/global_bloc/sync/sync_cubit.dart';
import 'package:event_rsvp/screens/authentication/model/user/userModel.dart';
import 'package:event_rsvp/screens/event/database/attendance/attendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

// Define the states
abstract class OnlineOfflineState extends Equatable {
    @override
  List<Object> get props => [];
}


class OnlineState extends OnlineOfflineState {}

class OfflineState extends OnlineOfflineState {}

// Create the cubit to manage the online/offline state
class OnlineOfflineCubit extends Cubit<OnlineOfflineState> {
  OnlineOfflineCubit() : super(OnlineState());
  // Toggle online/offline
  void toggleOnlineStatus(bool isOnline) async {
    if (isOnline) {
      await AttendanceDatabase().syncToFirestore();
      emit(OnlineState());
    } else {
      emit(OfflineState());
    }
  }
  Future<void> logout() async {
      await AttendanceDatabase().logout();

  }

}
