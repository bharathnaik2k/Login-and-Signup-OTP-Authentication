import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/api/jwt_token.dart';
import 'package:login_auth/login_auth/models/snackbar_message.dart';
import 'package:login_auth/login_auth/screens/home_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerifyScreen extends StatelessWidget {
  final String? mobileNumber;
  const OTPVerifyScreen({super.key, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Verify OTP'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(30, 60, 87, 1),
        ),
      ),
      body: FractionallySizedBox(
        widthFactor: 1,
        child: PinputExample(mobileNumber: mobileNumber),
      ),
    );
  }
}

class PinputExample extends StatefulWidget {
  final String? mobileNumber;
  const PinputExample({super.key, required this.mobileNumber});

  @override
  State<PinputExample> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinputExample> {
  TextEditingController pinController = TextEditingController();

  void perTokenFUN() async {
    perToken = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    perTokenFUN();
    super.initState();
  }

  void verifyOTP() async {
    var url = "$baseUrl$verifyURL";
    var uri = Uri.parse(url);
    var response = await http.post(
      uri,
      body: jsonEncode({
        "phone_number": "+91${widget.mobileNumber.toString()}",
        "otp": pinController.text.toString()
      }),
    );
    log("Status code : ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      var token = decode['data']['token'];
      perToken.setString("token", token.toString());
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(token: token),
        ));
      });
    } else {
      snackBarMessage(context, "Invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Enter Your OTP"),
          const SizedBox(height: 18),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: pinController,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue),
            ),
            onPressed: () {
              if (pinController.text.length == 4) {
                setState(() {
                  verifyOTP();
                });
              } else {
                snackBarMessage(context, "Enter Valid OTP");
              }
            },
            child: const Text(
              '  Validate  ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
