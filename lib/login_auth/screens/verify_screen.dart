import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
      backgroundColor: const Color.fromARGB(255, 106, 255, 0),
      appBar: AppBar(
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
  int secondsRemaining = 120;
  bool enableResend = false;
  Timer? timer;

  void perTokenFUN() async {
    perToken = await SharedPreferences.getInstance();
  }

  void _resendCode() async {
    try {
      var url = "$baseUrl$signInURL";
      var uri = Uri.parse(url);
      var response = await http.post(
        uri,
        body: jsonEncode(
            {"phone_number": "+91${widget.mobileNumber.toString()}"}),
      );
      log("Status code : ${response.statusCode.toString()}");
      if (response.statusCode == 201) {
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

    setState(() {
      secondsRemaining = 120;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    perTokenFUN();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
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
    const fillColor = Color.fromRGBO(255, 255, 255, 1);
    const borderColor = Color.fromRGBO(23, 171, 144, 1);

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 240,
              width: 240,
              child: Image.asset("assets/image/otp.png"),
            ),
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
                followingPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: const Color.fromARGB(255, 215, 215, 215),
                  ),
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 215, 215, 215),
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
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: enableResend,
                  child: GestureDetector(
                    onTap: enableResend ? _resendCode : null,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Visibility(
                  visible: enableResend == true ? false : true,
                  child: Text(
                    'Resend OTP After $secondsRemaining seconds',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              onPressed: () {
                // if (pinController.text.length == 4) {
                //   setState(() {
                //     verifyOTP();
                //   });
                // } else {
                //   snackBarMessage(context, "Enter Valid OTP");
                // }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HomeScreen(token: "token"),
                ));
              },
              child: const Text(
                '  Validate  ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
