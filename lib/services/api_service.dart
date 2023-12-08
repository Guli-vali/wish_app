import 'dart:io';

import 'package:flutter/services.dart';
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
    required creator,
    int price = 0,
    String category = 'Other',
    String? itemUrl,
    File? selectedPhoto,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'price': price,
      'category': category,
      'imageUrl': 'https://i.imgur.com/Fu24wgy.jpg',
      'itemUrl': itemUrl,
      'creator': creator,
    };

    // check if image attached
    List<http.MultipartFile> files = [];
    if (selectedPhoto != null) {
      files.add(
        await http.MultipartFile.fromPath('photoUrl', selectedPhoto.path),
      );
    }

    final record =
        await pb.collection('wishes').create(body: body, files: files);
    var recordMap = record.toJson();

    recordMap['imageUrl'] = recordMap['imageUrl'];
    if (selectedPhoto != null) {
      recordMap['imageUrl'] =
          pb.files.getUrl(record, record.data['photoUrl']).toString();
    }

    return recordMap;
  }

  Future getWishes() async {
    final records = await pb.collection(_COLLECTION_NAME).getFullList(
          sort: '-created'
        );
    var recordMap = [];
    for (final rec in records) {
      var recordJson = rec.toJson();

      if (!rec.data['photoUrl'].isEmpty){
        recordJson['imageUrl'] =
            pb.files.getUrl(rec, rec.data['photoUrl']).toString();
      }
      recordMap.add(recordJson);
    }
    return recordMap;
  }

  Future logIn({
    required email,
    required password,
  }) async {
    try {
      final authData = await pb.collection('users').authWithPassword(
            email,
            password,
          );
      // save auth related prefKeys
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(PrefKeys.accessTokenPrefsKey, pb.authStore.token);
      prefs.setString(
          PrefKeys.accessModelPrefsKey, pb.authStore.model.id ?? '');

      return authData.toJson();
    } on ClientException catch (ex) {
      if (ex.statusCode == 400) {
        throw ClientException(
            originalError:
                'Authentication failed. Please check your username/password');
      }
      if (ex.isAbort) {
        throw ClientException(
            originalError:
                'Sorry, it appears our server are currently down. We are working to address the problem. Please try again later');
      }
    }
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
    final loginState = await tryRefreshToken();
    return loginState;
  }

  Future<bool> tryRefreshToken() async {
    if (pb.authStore.isValid) {
      final prefs = await SharedPreferences.getInstance();
      try {
        await pb.collection('users').authRefresh();
      } on ClientException catch (ex) {
        if (ex.statusCode == 401) {
          return false;
        }
      }
      prefs.setString(PrefKeys.accessTokenPrefsKey, pb.authStore.token);
      prefs.setString(
          PrefKeys.accessModelPrefsKey, pb.authStore.model.id ?? '');
    }
    return pb.authStore.isValid;
  }

  Future signUp({
    required name,
    required email,
    required password,
    required passwordConfirm,
    File? selectedAvatar,
  }) async {
    try {
      final body = <String, dynamic>{
        "email": email,
        "emailVisibility": true,
        "password": password,
        "passwordConfirm": passwordConfirm,
        "name": name,
      };
    
      List<http.MultipartFile> files = [];
      if (selectedAvatar != null) {
        files.add(
          await http.MultipartFile.fromPath('avatar', selectedAvatar.path),
        );
      } else {
        var bytes = (await rootBundle.load('assets/images/avatar_placeholder1.png')).buffer.asUint8List();
        files.add(
          http.MultipartFile.fromBytes('avatar', bytes, filename: 'avatar_placeholder1.png'),
        );
      }

      final record = await pb.collection('users').create(body: body, files: files);
      return record.toJson();
    } on ClientException catch (ex) {
      if (ex.statusCode == 400) {
        throw ClientException(
            originalError:
                'Sign up failed. Please check all the values you submit');
      }
      if (ex.statusCode == 403) {
        throw ClientException(
            originalError: 'We are sorry, this action restricted');
      }
      if (ex.isAbort) {
        throw ClientException(
            originalError:
                'Sorry, it appears our server are currently down. We are working to address the problem. Please try again later');
      }
    }
  }

  Future getProfile(String modelId) async {
    final record = await pb.collection('users').getOne(
          modelId,
        );
    var recordMap = record.toJson();
    recordMap['avatar_url_full'] = pb.files
        .getUrl(record, record.data['avatar'], thumb: '100x250')
        .toString();
    return recordMap;
  }
}


final pocketbaseApiService = ApiServicePocketBase();
