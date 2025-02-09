
import 'package:event_rsvp/screens/authentication/bloc/user/auth_bloc.dart';
import 'package:event_rsvp/screens/authentication/model/user/user_entity.dart';

import '../../model/user/userModel.dart';

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}
