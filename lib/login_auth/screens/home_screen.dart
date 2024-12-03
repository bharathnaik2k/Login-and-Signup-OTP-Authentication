import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/api/jwt_token.dart';
import 'package:login_auth/login_auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;

  void getUser() async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    var id = decodedToken['sub'];
    var url = "$baseUrl/users/$id/details";
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    var decode = jsonDecode(response.body);
    log("Status code : ${response.statusCode.toString()}");
    setState(() {
      userData = decode;
    });
  }

  List<dynamic>? post;

  void getPosts() async {
    var url = '$baseUrl$getpostsURL';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    log("Status code : ${response.statusCode.toString()}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      var decode = jsonDecode(response.body)['data'] as List;
      setState(() {
        post = decode;
      });
    }
  }

  @override
  void initState() {
    getUser();
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: userData == null
            ? const Center(child: CircularProgressIndicator())
            : Text(
                'Hello, ${userData?['data']?['name'] ?? ""}',
                style: const TextStyle(color: Colors.white),
              ),
      ),
      body: post == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: post?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            post?[index]['author']['name'].toString() ?? ""),
                        leading:
                            Image.network(post?[index]['author']['photo_url']),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () async {
            perToken = await SharedPreferences.getInstance();
            setState(() {
              perToken.setString("token", "null");
              const LoginScreen();
            });
          },
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue)),
          child: const Text(
            "LogOut",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
