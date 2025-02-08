import 'package:event_rsvp/screens/authentication/bloc/user/auth_initial.dart';
import 'package:event_rsvp/screens/authentication/bloc/user/auth_error.dart';
import 'package:event_rsvp/screens/authentication/bloc/user/auth_loading.dart';
import 'package:event_rsvp/screens/authentication/bloc/user/auth_success.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '/core/usecases/auth_use_case.dart';


abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}



class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;


  AuthCubit(this.signUpUseCase) : super(AuthInitial());

  Future<void> signUp(String name, String email, String phone, String password, String confirmPassword) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase.execute(email, password, name, phone);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
    
  }

  Future<void> signIn(String email, String password) async
  {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase.signIn(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
