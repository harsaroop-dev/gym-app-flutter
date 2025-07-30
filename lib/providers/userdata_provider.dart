import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDataNotifier extends StateNotifier<User?> {
  UserDataNotifier() : super(null);

  void addUser(User? user) {
    state = user;
  }
}

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, User?>((ref) => UserDataNotifier());
