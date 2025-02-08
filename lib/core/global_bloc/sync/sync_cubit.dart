import 'package:flutter_bloc/flutter_bloc.dart';

enum SyncStatus { syncing, done, error }

class SyncCubit extends Cubit<SyncStatus> {
  SyncCubit() : super(SyncStatus.syncing); 

  void syncDone() => emit(SyncStatus.done);

  void syncError() => emit(SyncStatus.error);
}
