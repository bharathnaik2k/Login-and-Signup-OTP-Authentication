import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/api/jwt_token.dart';
import 'package:login_auth/login_auth/model_class/getpostslist_modelclass.dart';
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

  final List<ListModelclass> _getPostsList = [];
  Future<List<ListModelclass>> getPosts() async {
    var url = Uri.parse("$baseUrl$getpostsURL");
    final response = await http.get(url);
    log("Status code : ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map['data'];
      if (data.isNotEmpty) {
        for (int i = 0; i < data.length; i++) {
          if (data[i] != null) {
            setState(() {
              Map<String, dynamic> map = data[i];
              _getPostsList.add(ListModelclass.fromJson(map));
            });
          }
        }
      }

      return _getPostsList;
    } else {
      throw Exception('Failed to load post');
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
      body: _getPostsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: GridView.builder(
                    itemCount: _getPostsList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1),
                    itemBuilder: (context, index) {
                      DateTime dateValue = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                          .parseUTC(_getPostsList[index].createdAt.toString())
                          .toLocal();
                      String formattedDate =
                          DateFormat("hh:mm a dd MMM yyyy").format(dateValue);
                      return Card(
                        color: const Color.fromARGB(255, 255, 243, 109),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridTile(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      color: Colors.white,
                                      Icons.account_circle_outlined,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black, blurRadius: 10)
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getPostsList[index]
                                          .author!
                                          .name
                                          .toString(),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                _getPostsList[index].author!.photoUrl == null
                                    ? const CircularProgressIndicator()
                                    : Container(
                                        height: 220,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 230, 230, 230),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                _getPostsList[index]
                                                    .author!
                                                    .photoUrl
                                                    .toString()),
                                          ),
                                        ),
                                      ),
                                Text(
                                  _getPostsList[index].description.toString(),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.favorite,
                                        color:
                                            _getPostsList[index].liked == true
                                                ? Colors.red
                                                : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${_getPostsList[index].totalLikes.toString()} Likes',
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${formattedDate.substring(0, 8)} - ${formattedDate.substring(9, 20)}',
                                      style: const TextStyle(
                                        overflow: TextOverflow.fade,
                                        color: Color.fromARGB(255, 0, 125, 174),
                                        fontSize: 10.0,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
