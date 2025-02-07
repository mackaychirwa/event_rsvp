import '/models/user/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp(String email, String password);
}
