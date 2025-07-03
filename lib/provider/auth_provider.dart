import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  String? userID;
  String? errorMessage;

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('https://api.accounts.vikncodes.com/api/v1/users/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'is_mobile': true,
        }),
      );

      final responseData = jsonDecode(response.body);
      final data = responseData['data'];

      if (response.statusCode == 200 && data != null) {
        if (data['access'] != null && data['user_id'] != null) {
          token = data['access'];
          userID = data['user_id'].toString();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token!);
          await prefs.setString('userID', userID!);
          print('token:$token');
          print(username);
          print(password);
          print('userId: $userID');

          errorMessage = null;
          notifyListeners();
          return true;
        } else {
          errorMessage = responseData['error'] ?? "Login failed";
          print("Missing 'access' or 'user_id' in response: ${response.body}");
          return false;
        }
      } else {
        errorMessage = responseData['error'] ?? "Login failed";
        print("Login failed: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      print("Login exception: $e");
      return false;
    }
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token = null;
    userID = null;
    notifyListeners();
  }
}
