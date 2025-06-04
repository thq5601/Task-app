import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepo {
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode != 201){
        throw jsonDecode(res.body)['error'] ;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> login() {}
}
