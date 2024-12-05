import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/screens/signup_screen.dart';
import 'package:login_auth/login_auth/screens/verify_screen.dart';
import 'package:login_auth/login_auth/widgets/snackbar_message.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileNumber = TextEditingController();
  void logIN() async {
    try {
      var url = "$baseUrl$signInURL";
      var uri = Uri.parse(url);
      var response = await http.post(
        uri,
        body:
            jsonEncode({"phone_number": "+91${mobileNumber.text.toString()}"}),
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
        snackBarMessage(context, "OTP Sent Successfull");
      } else if (response.statusCode == 400) {
        snackBarMessage(context, "User Does Not Exit. Create a Account");
      } else {
        snackBarMessage(context, "${response.statusCode}");
      }
    } on TimeoutException {
      snackBarMessage(context, "TimeOut");
    } on SocketException {
      snackBarMessage(context, "No Internet");
    } on Error catch (e) {
      snackBarMessage(context, "$e");
    }
  }

  void fillNumberErorr() {
    snackBarMessage(context, "Enter Correct Number");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 255, 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 35),
                SizedBox(
                  height: 240,
                  width: 240,
                  child: Image.asset("assets/image/login1.png"),
                ),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: mobileNumber,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(),
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
                      mobileNumber.length == 10 ? logIN() : fillNumberErorr();
                    });
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Create Account"),
            const SizedBox(width: 5),
            GestureDetector(
              child: const Text(
                "SignUp",
                style: TextStyle(
                    color: Color.fromARGB(255, 153, 0, 255),
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
