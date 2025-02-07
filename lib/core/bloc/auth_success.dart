
import 'package:event_rsvp/core/bloc/auth_bloc.dart';
import 'package:event_rsvp/models/user/user_entity.dart';

class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}
