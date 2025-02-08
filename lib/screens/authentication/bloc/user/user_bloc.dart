import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

import '../../model/user/userModel.dart';

// Define the user states
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

// Define the events
abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {}

// Create the Cubit to manage the user state
class UserCubit extends Cubit<UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late Box<UserModel> getUser;

  // UserCubit() : super(UserInitial());
     UserCubit() : super(UserInitial()) {
    _openBox();
  }
 Future<void> _openBox() async {
    getUser = await Hive.openBox<UserModel>('userBox');
  }


  void fetchUser() async {
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

            // Create a UserModel instance and store it in the box
            UserModel userModel = UserModel.fromFirestore(userDoc);
                  // Store the user model
            await getUser.put('user', userModel);

            // getUser.put('user', userDoc);
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
