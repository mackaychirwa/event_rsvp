import 'package:event_rsvp/core/bloc/auth_initial.dart';
import 'package:event_rsvp/core/bloc/auth_error.dart';
import 'package:event_rsvp/core/bloc/auth_loading.dart';
import 'package:event_rsvp/core/bloc/auth_success.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../models/user/user_model.dart';
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
        // var box = await Hive.openBox('userBox');
        // await box.put('user', UserModel(email: user.email, username: user.displayName));
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
