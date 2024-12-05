import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/widgets/snackbar_message.dart';
import 'package:login_auth/login_auth/screens/login_screen.dart';
import 'package:login_auth/login_auth/screens/verify_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController userType = TextEditingController(text: "USER");
  TextEditingController email = TextEditingController();

  signUP() async {
    var url = "$baseUrl$signUpURL";
    var uri = Uri.parse(url);
    var response = await http.post(
      uri,
      body: jsonEncode({
        "phone_number": "+91${mobileNumber.text.toString()}",
        "user_type": userType.text.toString(),
        "name": name.text.toString(),
        "email": email.text.toString(),
      }),
    );
    log("Status code : ${response.statusCode.toString()}");
    if (response.statusCode == 201) {
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => OTPVerifyScreen(
            mobileNumber: mobileNumber.text.toString(),
          ),
        ));
      });
      snackBarMessage(context, "OTP Sent Successful");
    } else if (response.statusCode == 400) {
      snackBarMessage(context, "Account Already Exits! Please Login");
    } else {
      snackBarMessage(context, "${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 255, 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 170,
                    width: 170,
                    child: Image.asset("assets/image/signup.png"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: false,
                    controller: userType,
                    decoration: const InputDecoration(
                      hintText: "User Type",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                      fillColor: Color.fromARGB(255, 212, 212, 212),
                      filled: true,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: mobileNumber,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: "Enter Moblie Number",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          '+91',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      prefixStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize: const MaterialStatePropertyAll(
                        Size(160, 45),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.blue),
                    ),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        if (name.text.isNotEmpty &&
                            email.text.isNotEmpty &&
                            mobileNumber.text.length == 10) {
                          signUP();
                        } else {
                          snackBarMessage(context, "Fill All Details");
                        }
                      });
                    },
                    child: const Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already Have an Account"),
            const SizedBox(width: 5),
            GestureDetector(
              child: const Text(
                "LogIn",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
