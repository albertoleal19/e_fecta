import 'package:e_fecta/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUser();
}
