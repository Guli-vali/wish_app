import 'dart:core';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/services/api_service.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await pocketbaseApiService.logIn(
      email: email,
      password: password,
    );
    state = pocketbaseApiService.pb.authStore.isValid;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
    File? selectedAvatar,

  }) async {
    await pocketbaseApiService.signUp(
      name: name,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
      selectedAvatar: selectedAvatar,
    );

    await login(
      email: email,
      password: password,
    );

    state = pocketbaseApiService.pb.authStore.isValid;
  }

  Future<void> logout() async {
    await pocketbaseApiService.logOut();
    state = pocketbaseApiService.pb.authStore.isValid;
  }

  Future<void> autoLogin() async {
    final loginData = await pocketbaseApiService.tryAutoLogin();
    state = loginData;
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);
