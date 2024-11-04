import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.tokens,
    this.isAdmin = true,
  });

  final int id;
  final String username;
  final String email;
  final double tokens;
  final bool isAdmin;

  @override
  List<Object?> get props => [id, username, email, tokens, isAdmin];
}
