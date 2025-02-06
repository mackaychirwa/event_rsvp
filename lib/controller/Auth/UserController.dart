// import 'package:get/get.dart';
//
// import '../../feature/authentication/model/user.dart';
// import '../../feature/authentication/service/UserService.dart';
//
//
// class UserController extends GetxController {
//   final UserService _userService = UserService();
//
//   Future<void> registerUser({
//     required String phoneNumber,
//     required String firstName,
//     required String lastName,
//     required String password,
//   }) async {
//     final user = User(
//       phoneNumber: phoneNumber,
//       firstName: firstName,
//       lastName: lastName,
//       password: password,
//     );
//
//
//     final registeredUser = await _userService.registerUser(user);
//
//     if (registeredUser != null) {
//       // Handle success
//       print('User registered successfully: $registeredUser');
//     } else {
//       // Handle failure
//       print('Failed to register user');
//     }
//   }
//
// }
