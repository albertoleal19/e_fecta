import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.tokens,
    this.isAdmin = true,
  });

  final String id;
  final String username;
  final String email;
  final int tokens;
  final bool isAdmin;

  @override
  List<Object?> get props => [id, username, email, tokens, isAdmin];

  User copyWith({
    String? id,
    String? username,
    String? email,
    int? tokens,
    bool? isAdmin,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        tokens: tokens ?? this.tokens,
        isAdmin: isAdmin ?? this.isAdmin,
      );
}
