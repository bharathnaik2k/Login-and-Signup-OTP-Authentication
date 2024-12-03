import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_auth/login_auth/screens/home_screen.dart';
import 'package:login_auth/login_auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences perToken = await SharedPreferences.getInstance();
  String? token = perToken.getString('token');
  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (token != "null" && !JwtDecoder.isExpired(token!))
          ? HomeScreen(token: token!)
          : const LoginScreen(),
    );
  }
}
