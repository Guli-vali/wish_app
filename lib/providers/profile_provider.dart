import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishes_app/models/pref_keys.dart';
import 'package:wishes_app/models/profile.dart';
import 'package:wishes_app/providers/auth_provider.dart';
import 'package:wishes_app/services/api_service.dart';

class ProfileNotifier extends Notifier<Profile> {
  @override
  Profile build() {
    return const Profile(
      avatarUrl:
          'https://cdn4.iconfinder.com/data/icons/political-elections/50/48-1024.png',
      name: 'Anonymus',
      email: 'anon@example.com',
    );
  }

  Future<void> getProfile() async {
    if (ref.read(authProvider)) {
      final prefs = await SharedPreferences.getInstance();
      final modelId = prefs.getString(PrefKeys.accessModelPrefsKey)!;
      final profile = await pocketbaseApiService.getProfile(modelId);

      state = Profile(
        avatarUrl: profile['avatar_url_full'],
        name: profile['name'],
        email: profile['email'],
      );
    }
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, Profile>(
  ProfileNotifier.new,
);
