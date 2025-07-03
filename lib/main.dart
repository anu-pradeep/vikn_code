import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vikn_code/provider/auth_provider.dart';
import 'package:vikn_code/screens/login.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),

  ],
      child:   MyApp()
  ) );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CabZing',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}