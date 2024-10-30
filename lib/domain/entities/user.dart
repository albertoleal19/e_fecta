import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.tokens,
  });

  final int id;
  final String username;
  final String email;
  final double tokens;

  @override
  List<Object?> get props => [id, username, email, tokens];
}
