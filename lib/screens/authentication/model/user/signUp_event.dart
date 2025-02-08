
import 'package:event_rsvp/screens/authentication/bloc/user/auth_event.dart';

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [name, email, phone, password, confirmPassword];
}