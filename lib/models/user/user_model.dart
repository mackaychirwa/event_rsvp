import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String email;
  
  @HiveField(1)
  final String username;

  // Add other fields you want to store

  UserModel({required this.email, required this.username});
}
