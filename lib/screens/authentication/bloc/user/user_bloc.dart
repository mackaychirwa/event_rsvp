import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

import '../../model/user/userModel.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final String userName;

  UserLoaded(this.userName);

  @override
  List<Object> get props => [userName];
}

class UserError extends UserState {
  final String error;

  UserError(this.error);

  @override
  List<Object> get props => [error];
}

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {}

class UserCubit extends Cubit<UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late Box<UserModel> getUser;

  UserCubit() : super(UserInitial());

 Future<void> _openBox() async {
    getUser = await Hive.openBox<UserModel>('userBox');
  }


  void fetchUser() async {
    await _openBox();
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        var storedUser = getUser.get('user', defaultValue: null);

        if (storedUser != null) {
          emit(UserLoaded(storedUser.fullname));
        } else {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            String userName = userDoc['fullname'] ?? "Guest";

            UserModel userModel = UserModel.fromFirestore(userDoc) ;
            await getUser.put('user', userModel);
            emit(UserLoaded(userName));
          } else {
            emit(UserError("User data not found"));
          }
        }
      } else {
        emit(UserError("No user found"));
      }
    } catch (e) {
      emit(UserError("Failed to load user: $e"));
    }
  }
}
