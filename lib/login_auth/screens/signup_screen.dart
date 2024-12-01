import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/screens/login_screen.dart';

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
    if (response.statusCode == 201) {
      var snackBar = const SnackBar(content: Text('OTP Sent Sccuessfull'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (response.statusCode == 400) {
      var snackBar = const SnackBar(content: Text('Account Already Exits'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var snackBar = SnackBar(content: Text(response.statusCode.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
              const Icon(Icons.account_box, size: 55),
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
                  backgroundColor: const MaterialStatePropertyAll(Colors.blue),
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    if (name.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        mobileNumber.text.length == 10) {
                      signUP();
                    } else {
                      var snackBar =
                          const SnackBar(content: Text('Fill the Details'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
