import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/screens/signup_screen.dart';
import 'package:login_auth/login_auth/screens/verify_screen.dart';
import 'package:pinput/pinput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileNumber = TextEditingController();
  logIN() async {
    var url = "$baseUrl$signInURL";
    var uri = Uri.parse(url);
    var response = await http.post(
      uri,
      body: jsonEncode({"phone_number": "+91${mobileNumber.text.toString()}"}),
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
      var snackBar = const SnackBar(content: Text('OTP Sent Successfull'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (response.statusCode == 400) {
      var snackBar =
          const SnackBar(content: Text('User Does Not Exit. Create a Account'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var snackBar = SnackBar(content: Text('${response.statusCode}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  fillNumberErorr() {
    var snackBar = const SnackBar(content: Text('Enter The Correct Number'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.login, size: 85),
              const SizedBox(height: 10),
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
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  hintText: "Enter Moblie Number",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 151, 151, 151),
                  ),
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
                  backgroundColor: const MaterialStatePropertyAll(Colors.blue),
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
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
