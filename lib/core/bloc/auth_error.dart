import 'package:event_rsvp/core/bloc/auth_bloc.dart';

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}
