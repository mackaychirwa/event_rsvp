import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Define the states
abstract class OnlineOfflineState extends Equatable {
    @override
  List<Object> get props => [];
}


class OnlineState extends OnlineOfflineState {}

class OfflineState extends OnlineOfflineState {}

// Create the cubit to manage the online/offline state
class OnlineOfflineCubit extends Cubit<OnlineOfflineState> {
  OnlineOfflineCubit() : super(OnlineState()); // Default to online state

  // Toggle online/offline
  void toggleOnlineStatus(bool isOnline) {
    if (isOnline) {
      emit(OnlineState());
    } else {
      emit(OfflineState());
    }
  }
}
