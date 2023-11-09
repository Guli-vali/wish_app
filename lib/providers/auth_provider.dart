import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/services/api_service.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  final apiService = ApiServicePocketBase();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final _ = await apiService.logIn(
      email: email,
      password: password,
    );
    state = apiService.pb.authStore.isValid;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final signUpResponse = await apiService.signUp(
      name: name,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );

    final _ = await login(
      email: email,
      password: password,
    );

    state = apiService.pb.authStore.isValid;
  }

  Future<void> logout() async {
    final _ = await apiService.logOut();
    state = apiService.pb.authStore.isValid;
  }

  Future<void> autoLogin() async {
    final loginData = await apiService.tryAutoLogin();
    state = loginData;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>(
  (ref) => AuthNotifier(),
);
