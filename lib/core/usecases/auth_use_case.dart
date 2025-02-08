import 'package:event_rsvp/screens/authentication/database/registration/userRegistrationDatabase.dart';

import '../../screens/authentication/model/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserEntity> execute(
      String email, String password, String fullname, String phone) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await UserRegistrationDatabase().createUserData(fullname, email, phone, credential.user!.uid);
    return UserEntity(
      uid: credential.user!.uid,
      email: credential.user!.email!,
      displayName: credential.user!.displayName ?? '',
    );
  }

  Future<UserEntity> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserEntity(
      uid: credential.user!.uid,
      email: credential.user!.email!,
      displayName: credential.user!.displayName ?? '',
    );
  }
}
