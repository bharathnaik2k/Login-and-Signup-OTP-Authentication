import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/login_auth/api/api_address.dart';

class HomeScreen extends StatefulWidget {
  final String id;
  const HomeScreen({super.key, required this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  getUser() async {
    var url = "https://api.yes-me.com/users/${widget.id}/details";
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    var decode = jsonDecode(response.body);
    setState(() {
      userData = decode;
    });
  }

  Map<String, dynamic>? fecthPosts;
  List<dynamic>? post;

  getPosts() async {
    var url = getpostsURL;
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var decode = jsonDecode(response.body)['data'] as List;
      print(decode.toString());
      log(decode.toString());
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
                userData?['data']?['name'] ?? "",
                style: const TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
              onPressed: () {
                getPosts();
              },
              icon: const Icon(Icons.replay)),
        ],
      ),
      body: post == null
          ? const CircularProgressIndicator()
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
                )
              ],
            ),
    );
  }
}
