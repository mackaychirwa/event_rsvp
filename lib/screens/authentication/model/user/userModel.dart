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
}
