import 'package:e_fecta/data/user_repository.dart';
import 'package:e_fecta/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> authenticate(String email, String password);

  Future<User?> getAuthenticatedUser();
}
