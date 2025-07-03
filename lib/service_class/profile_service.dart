
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileApiService {
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userID');
    final token = prefs.getString('token');

    if (userId == null || token == null) {
      print('User ID or token not found in SharedPreferences');
      return null;
    }

    final url = Uri.parse(
        'https://api.viknbooks.com/api/v10/users/user-view/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['StatusCode'] == 6000) {
          return decoded;
        } else {
          print('Unexpected StatusCode: ${decoded['StatusCode']}');
        }
      } else {
        print('Failed to load user profile');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }

    return null;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
