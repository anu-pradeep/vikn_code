import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../utils/colors.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CustomColors.blackColor,
                const Color(0xFF1C1C1E),
                CustomColors.blackColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset('assets/images/language-hiragana.png'),
                    SizedBox(width: 05),
                    Text(
                      'English',
                      style: TextStyle(
                        color: CustomColors.whiteColor,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.whiteColor,
                      fontFamily: 'PoppinsRegular',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Login to your vikn account',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      fontFamily: 'PoppinsRegular',
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: usernameController,
                        style: TextStyle(color: CustomColors.whiteColor),
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: Colors.white60,
                            fontFamily: 'PoppinsRegular',
                          ),
                          labelText: 'Username',labelStyle: TextStyle(
                          color: Colors.white60,
                          fontFamily: 'PoppinsRegular',
                        ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: CustomColors.blueColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                      Divider(
                        color: Colors.white70,
                        thickness: 1.4,
                        indent: 10,
                        endIndent: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: !showPassword,
                        style: TextStyle(color: CustomColors.whiteColor),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.white60,
                            fontFamily: 'PoppinsRegular',
                          ),
                          labelText: 'Password',labelStyle: TextStyle(
                          color: Colors.white60,
                          fontFamily: 'PoppinsRegular',
                        ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: CustomColors.blueColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: CustomColors.blueColor,
                            ),
                            onPressed: () {
                              setState(() => showPassword = !showPassword);
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgotten Password?',
                      style: TextStyle(
                        color: CustomColors.blueColor,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(left: 110,right: 110),
                  child: ElevatedButton(
                    onPressed: () async {
                      final username = usernameController.text.trim();
                      final password = passwordController.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter both username and password',
                              style: TextStyle(fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        );
                        return;
                      }

                      if (kDebugMode) {
                        print('Trying login with → username: $username, password: $password');
                      }

                      bool loggedIn = await authProvider.login(username, password);
                      if (loggedIn) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => DashboardScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              authProvider.errorMessage ?? 'Login failed',
                              style: TextStyle(fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(fontFamily: 'PoppinsRegular',color: CustomColors.whiteColor),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward,color: CustomColors.whiteColor,),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 140),
                
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Don't have an account",
                        style: TextStyle(fontFamily: 'PoppinsRegular',color: CustomColors.whiteColor),
                      ),
                      Text(
                        'Sign up now!',
                        style: TextStyle(fontFamily: 'PoppinsRegular',color: CustomColors.blueColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
