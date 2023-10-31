import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

class ApiService {
  // ignore: constant_identifier_names
  static const _BASE_URL =
      'flutter-prep-311e4-default-rtdb.europe-west1.firebasedatabase.app';
  // ignore: constant_identifier_names
  static const _WISH_TABLE = 'wishes-list.json';

  final url = Uri.https(_BASE_URL, _WISH_TABLE);

  Future createWish({
    required title,
    required price,
    required category,
    required itemUrl,
    required selectedImage,
  }) async {
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'title': title,
          'price': price,
          'category': category,
          'itemUrl': itemUrl,
          'imageUrl': selectedImage,
        },
      ),
    );
  }

  Future getWishes() async {
    return await http.get(url);
  }
}

class ApiServicePocketBase {
  // ignore: constant_identifier_names
  static const _BASE_URL = 'http://127.0.0.1:8090';
  // ignore: constant_identifier_names
  static const _COLLECTION_NAME = 'wishes';

  final pb = PocketBase(_BASE_URL);

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
}
