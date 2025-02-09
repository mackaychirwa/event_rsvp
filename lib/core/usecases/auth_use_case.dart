import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_rsvp/screens/authentication/database/registration/userRegistrationDatabase.dart';

import '../../screens/authentication/model/user/userModel.dart';
import '../../screens/authentication/model/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // Future<UserModel> execute(
  //     String email, String password, String fullname, String phone) async {
  //   final credential = await _firebaseAuth.createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   await UserRegistrationDatabase().createUserData(fullname, email, phone, credential.user!.uid);
  //   return UserEntity(
  //     uid: credential.user!.uid,
  //     email: credential.user!.email!,
  //     displayName: credential.user!.displayName ?? '',
  //   );
  // }
  Future<UserModel> execute(String email, String password, String fullname, String phone) async {
      try {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user;
        if (user == null) {
          throw FirebaseAuthException(
              code: 'user-creation-failed', message: 'Failed to create user.');
        }

        // Save user details in Firestore
        await UserRegistrationDatabase()
            .createUserData(fullname, email, phone, user.uid);

        // Construct and return the UserModel
        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          fullname: fullname,
          account_type: 'user', // Default account type if not provided
        );
      } catch (e) {
        print("User creation failed: $e");
        rethrow;
      }
    }

  // Future<UserEntity> signIn(String email, String password) async {
  //   final credential = await _firebaseAuth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   return UserModel(
  //     uid: credential.user!.uid,
  //     email: credential.user!.email!,
  //     displayName: credential.user!.displayName ?? '',
  //   );
  // }
  Future<UserModel> signIn(String email, String password) async {
  try {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User not found');
    }

    // Fetch user details from Firestore
    final docSnapshot = await db
        .collection('Users')
        .doc(user.uid)
        .get();

    if (!docSnapshot.exists) {
      throw FirebaseAuthException(
          code: 'user-data-missing', message: 'User data not found in Firestore');
    }

    // Convert Firestore document to UserModel
    final userModel = UserModel.fromFirestore(docSnapshot);

    return userModel;
  } catch (e) {
    print("Sign-in failed: $e");
    rethrow; 
  }
}

}
