import 'package:e_fecta/domain/entities/user.dart';
import 'package:e_fecta/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUser() {
    return Future.value(
      const User(
        email: 'alberto@efecta.com',
        username: 'algu01',
        id: 1,
        tokens: 40,
      ),
    );
  }
}
