
import 'package:event_rsvp/screens/authentication/bloc/user/auth_bloc.dart';
import 'package:event_rsvp/screens/authentication/model/user/user_entity.dart';

class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}
