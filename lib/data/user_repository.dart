import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_fecta/domain/entities/user.dart' as user;
import 'package:e_fecta/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum GetUserBy { email, uid, username }

extension GetUserByExt on GetUserBy {
  String toDataValue() {
    switch (this) {
      case GetUserBy.email:
        return 'email';
      case GetUserBy.uid:
        return 'uid';
      case GetUserBy.username:
        return 'username';
    }
  }
}

class UserRepositoryImpl implements UserRepository {
  final firestore = FirebaseFirestore.instance;
  final authenticator = FirebaseAuth.instance;

  @override
  Future<user.User?> getAuthenticatedUser() async {
    final authUser = authenticator.currentUser;
    if (authUser == null) return null;

    final userInfo = (await firestore
            .collection('users')
            .where(GetUserBy.uid.toDataValue(), isEqualTo: authUser?.uid)
            .limit(1)
            .get())
        .docs
        .first;

    return user.User(
      email: userInfo['email'],
      username: userInfo['username'],
      id: userInfo.id,
      tokens: userInfo['balance'],
      isAdmin: userInfo['type'] == 'admin',
    );
  }

  @override
  Future<user.User> authenticate(String email, String password) async {
    try {
      final credential = await authenticator.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userInfo = (await firestore
              .collection('users')
              .where(GetUserBy.uid.toDataValue(),
                  isEqualTo: credential.user?.uid ?? '')
              .limit(1)
              .get())
          .docs
          .first;

      return user.User(
        email: userInfo['email'],
        username: userInfo['username'],
        id: userInfo.id,
        tokens: userInfo['balance'],
        isAdmin: userInfo['type'] == 'admin',
      );
    } catch (e) {
      rethrow;
    }

    //return await getUser(GetUserBy.uid, credential.user?.uid ?? '');
  }
}
