import 'package:e_fecta/data/user_repository.dart';
import 'package:e_fecta/domain/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final UserRepository userRepository = UserRepositoryImpl();

  Future<void> loginUser(String username, String password) async {
    try {
      print('At Login cubit');
      await userRepository.authenticate(username, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed());
    }
  }
}
