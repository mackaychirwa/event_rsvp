import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRegistrationDatabase {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  final CollectionReference UsersList = FirebaseFirestore.instance.collection("Users");
  Future<void> createUserData(String fullname, String email, String phonenumber, String uid ) async {
    return await UsersList.doc(uid).set({
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
      'account_type': 'user',
    });
  }
}


