
import 'package:flutter/material.dart';
import '../service_class/profile_service.dart';
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
  final _profileApiService = ProfileApiService();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final profile = await _profileApiService.fetchUserProfile();
    if (profile != null) {
      setState(() {
        user = profile;
      });
    }
  }

  void logout() async {
    await _profileApiService.clearSession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blackColor,
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundImage:
                          AssetImage('assets/images/profile.png'),
                        ),
                        const SizedBox(width: 16),
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
                                  fontFamily: 'PoppinsRegular',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user!['data']['email'] ?? '',
                                style: TextStyle(
                                  color: CustomColors.pinkColor,
                                  fontSize: 14,
                                  fontFamily: 'PoppinsRegular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset('assets/images/edit.png'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
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
                                const SizedBox(width: 5),
                                Column(
                                  children: [
                                    const Text(
                                      ' 4.3★',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '2,211',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        fontFamily: 'PoppinsRegular',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'rides',
                                      style: TextStyle(
                                        color: CustomColors.pinkColor,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
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
                                    const SizedBox(height: 4),
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
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: logout,
                      child: Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
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
                              const SizedBox(width: 6),
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
              const SizedBox(height: 30),

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
