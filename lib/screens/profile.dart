import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/colors.dart';
import '../utils/profile_menu_Card.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;

  Future<void> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userID');
    final token = prefs.getString('token');

    if (userId == null || token == null) {
      print('User ID or token not found in SharedPreferences');
      return;
    }

    print('Retrieved userId: $userId');
    print('Retrieved token: $token');

    final url = Uri.parse(
      'https://api.viknbooks.com/api/v10/users/user-view/$userId',
    );
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded['StatusCode'] == 6000) {
          setState(() {
            user = decoded;
          });
        } else {
          print("Unexpected StatusCode: ${decoded['StatusCode']}");
        }
      } catch (e) {
        print('JSON decoding error: $e');
        print('Response body was: ${response.body}');
      }
    } else {
      print("Failed to load user");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blackColor,
      body: SafeArea(
        child: user == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Card
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:

                                AssetImage('assets/images/profile.png')
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user!['data']['first_name']} ${user!['data']['last_name']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: CustomColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'PoppinsRegular'
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      user!['data']['email'] ?? '',
                                      style: TextStyle(
                                        color:CustomColors.pinkColor,
                                        fontSize: 14,
                                        fontFamily: 'PoppinsRegular'
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Image.asset('assets/images/edit.png')
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(

                            children: [

                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: CustomColors.blackColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/Frame_kyc.png',
                                        height: 65,
                                      ),
                                      SizedBox(width: 05),
                                      Column(
                                        children: [
                                          Text(
                                            ' 4.3★',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '2,211',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                              fontFamily: 'PoppinsRegular'
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'rides',
                                            style: TextStyle(
                                                color: CustomColors.pinkColor,
                                                fontSize: 12,
                                                fontFamily: 'PoppinsRegular'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: CustomColors.blackColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/Frame_kyc.png',
                                        height: 65,
                                      ),

                                      Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '  KYC ',
                                                  style: TextStyle(
                                                    color:
                                                        CustomColors.whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Image.asset(
                                                    'assets/images/Vector.png',
                                                    width: 18,
                                                    height: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 4),
                                          Text(
                                            'Verified',
                                            style: TextStyle(
                                              color: CustomColors.greenColor,
                                              fontSize: 12,
                                              fontFamily: 'PoppinsRegular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: logout,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: CustomColors.blackColor,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/logout.png',
                                      color: CustomColors.redColor,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: CustomColors.redColor,
                                        fontSize: 16,
                                        fontFamily: 'PoppinsRegular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Menu Items
                    ProfileMenuItem(
                      imagePath: 'assets/images/badge-help.png',
                      title: 'Help',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      imagePath: 'assets/images/search-status.png',
                      title: 'FAQ',
                    ),
                    ProfileMenuItem(
                      imagePath: 'assets/images/Add-Person.png',
                      title: 'Invite Friends',
                    ),
                    ProfileMenuItem(
                      imagePath: 'assets/images/shield-search.png',
                      title: 'Terms of service',
                    ),
                    ProfileMenuItem(
                      imagePath: 'assets/images/security-safe.png',
                      title: 'Privacy Policy',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
