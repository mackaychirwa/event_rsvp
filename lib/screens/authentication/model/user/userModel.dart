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

  @HiveField(4)
  String account_type;
  UserModel({
    this.localId = 0,
    required this.uid,
    required this.email,
    required this.fullname,
    required this.account_type,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'] ?? '', 
      email: doc['email'] ?? '', 
      fullname: doc['fullname'] ?? 'Guest', 
      account_type: doc['account_type'] ?? 'user', 
    );
  }

  // Convert UserModel object to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'account_type': account_type,
    };
  }
}
