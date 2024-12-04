import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/api/jwt_token.dart';
import 'package:login_auth/login_auth/models/list_model.dart';
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
    Map<String, dynamic> decodedToken = JwtDecoder.decode(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU2MjU1ODcsImlhdCI6MTczMzAzMzU4NywicGhvbmVfbnVtYmVyIjoiKzkxOTY4Njk1MTY1MCIsInN1YiI6Ijk0Y2ExM2Y1LTA2NjgtNDczZC04YTE5LTJmMWFkNjU4ZGRmNiIsInVzZXJfdHlwZSI6IlVTRVIifQ.U1o044XFSFmsL72QeY02HDnkRTXJ1YiPZBvo9vZbcv4");
    var id = decodedToken['sub'];
    var url = "$baseUrl/users/$id/details";
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    var decode = jsonDecode(response.body);
    // log("Status code : ${response.statusCode.toString()}");
    // log("Status code : ${decode.toString()}");

    setState(() {
      userData = decode;
    });
  }

  List<dynamic>? post;

  List<ListModelclass> po = [];

  Future<List<ListModelclass>> getPosts() async {
    var url = '$baseUrl$getpostsURL';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    var decode = jsonDecode(response.body)['data'] as List;
    // log("Status code : ${response.statusCode.toString()}");
    // log("Status code : ${response.body.toString()}");
    print(decode.toString());
    for (var i in decode) {
      setState(() {
        po.add(ListModelclass.fromJson(i));
        print(po.toString());
      });
    }
    return po;

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   var decode = jsonDecode(response.body)['data'] as List;
    //   setState(() {
    //     post = decode;
    //   });
    // }
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
        leading: userData == null
            ? const SizedBox()
            : Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: userData == null
            ? const SizedBox()
            : Text(
                'Hello, ${userData?['data']?['name'] ?? "Hello, User"}',
                style: const TextStyle(color: Colors.white),
              ),
      ),
      drawer: userData == null
          ? const SizedBox()
          : Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    // userData?['data']['photo_url'] == null
                    //     ? const Icon(Icons.account_circle_rounded)
                    //     : Image.network(userData?['data']['photo_url']),
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 130,
                    ),
                    Text(
                      userData?['data']?['name'] ?? "",
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    const Text("Contact Details : "),
                    const SizedBox(height: 10),

                    Text(
                        'Mob. No : ${userData?['data']?['phone_number'] ?? ""}'),
                    Text('Email : ${userData?['data']?['email'] ?? ""}'),

                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () async {
                              perToken = await SharedPreferences.getInstance();
                              setState(() {
                                perToken.setString("token", "null");
                              });
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                            },
                            style: const ButtonStyle(
                                minimumSize: MaterialStatePropertyAll(
                                    Size(double.infinity, 40)),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue)),
                            child: const Text(
                              "LogOut",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }
}
