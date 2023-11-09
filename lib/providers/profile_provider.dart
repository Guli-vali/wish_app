import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishes_app/models/pref_keys.dart';
import 'package:wishes_app/models/profile.dart';
import 'package:wishes_app/providers/auth_provider.dart';
import 'package:wishes_app/services/api_service.dart';

class ProfileNotifier extends StateNotifier<Profile> {
  ProfileNotifier(this.authState)
      : super(
          const Profile(
            avatarUrl:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRX4q0-hFsRa8s1kzziYZVHIW1zg-yH0S2POA&usqp=CAU',
            name: 'Anonymus',
            email: 'anon@example.com',
          ),
        );

  final authState;
  final api_service = ApiServicePocketBase();

  Future<void> getProfile() async {
    if (authState) {
      final prefs = await SharedPreferences.getInstance();
      final modelId = prefs.getString(PrefKeys.accessModelPrefsKey)!;
      final profile = await api_service.getProfile(modelId);

      state = Profile(
        avatarUrl: profile['avatar_url_full'],
        name: profile['name'],
        email: profile['email'],
      );
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile>(
  (ref) {
    final auth = ref.watch(authProvider);
    return ProfileNotifier(auth);
  },
);
