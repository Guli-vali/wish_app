import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishes_app/models/pref_keys.dart';

class ApiServicePocketBase {
  // ignore: constant_identifier_names
  static const _BASE_URL = 'http://127.0.0.1:8090';
  // ignore: constant_identifier_names
  static const _COLLECTION_NAME = 'wishes';

  final pb = PocketBase(_BASE_URL);

  bool get isAuth {
    return pb.authStore.isValid && pb.authStore.token.isNotEmpty;
  }

  Future createWish({
    required title,
    required price,
    required category,
    required itemUrl,
    required selectedImage,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'price': price,
      'category': category,
      'itemUrl': itemUrl,
      'imageUrl': selectedImage,
    };
    final record = await pb.collection('wishes').create(body: body);
    return record.toJson();
  }

  Future getWishes() async {
    final records = await pb.collection(_COLLECTION_NAME).getFullList(
          sort: '-created',
        );
    return records;
  }

  Future logIn({
    required email,
    required password,
  }) async {
    final authData = await pb.collection('users').authWithPassword(
          email,
          password,
        );

    // save auth related prefKeys
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefKeys.accessTokenPrefsKey, pb.authStore.token);
    prefs.setString(PrefKeys.accessModelPrefsKey, pb.authStore.model.id ?? '');

    return authData.toJson();
  }

  Future<void> logOut() async {
    pb.authStore.clear();

    // remove stored auth related prefKeys
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(PrefKeys.accessTokenPrefsKey);
    prefs.remove(PrefKeys.accessModelPrefsKey);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    pb.authStore.save(prefs.getString(PrefKeys.accessTokenPrefsKey) ?? '',
        prefs.getString(PrefKeys.accessModelPrefsKey) ?? '');
    if (!pb.authStore.isValid) {
      return false;
    }
    tryRefreshToken();
    return pb.authStore.isValid;
  }

  Future<bool> tryRefreshToken() async {
    if (pb.authStore.isValid) {
        final prefs = await SharedPreferences.getInstance();
        await pb.collection('users').authRefresh();
        prefs.setString(PrefKeys.accessTokenPrefsKey, pb.authStore.token);
        prefs.setString(PrefKeys.accessModelPrefsKey, pb.authStore.model.id ?? '');
    }
    return pb.authStore.isValid;
  }

  Future signUp({
    required name,
    required email,
    required password,
    required passwordConfirm,
  }) async {
    final body = <String, dynamic>{
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": name
    };
    final record = await pb.collection('users').create(body: body);
    return record.toJson();
  }

  Future getProfile(String modelId) async {
    final record = await pb.collection('users').getOne(
          modelId,
        );
    var record_map = record.toJson();
    record_map['avatar_url_full'] = pb.files
        .getUrl(record, record.data['avatar'], thumb: '100x250')
        .toString();
    return record_map;
  }
}
