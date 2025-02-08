import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

part 'userModel.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  int localId;

  @HiveField(1)
  String uid;

  @HiveField(2)
  String email;

  @HiveField(3)
  String fullname;

  UserModel({
    this.localId = 0,
    required this.uid,
    required this.email,
    required this.fullname,
  });

  // Factory constructor to create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      localId:
          doc['localId'] ?? 0, // Assuming `localId` is in Firestore as well
      uid: doc['uid'] ?? '', // Make sure `uid` is stored in Firestore
      email: doc['email'] ?? '', // Make sure `email` is stored in Firestore
      fullname: doc['fullname'] ??
          'Guest', // Default to 'Guest' if fullname is not available
    );
  }

  // Convert UserModel object to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'localId': localId,
      'uid': uid,
      'email': email,
      'fullname': fullname,
    };
  }
}
