import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinex/pages/home.dart';
import 'package:sentinex/pages/practice.dart';
import 'package:sentinex/providers/user_provider.dart';
import 'package:sentinex/resources/auth_methods.dart';
import 'package:sentinex/utils/my_colors.dart';
import 'package:sentinex/utils/utils.dart';
import 'package:sentinex/models/user.dart' as model;

import 'add_patrol_account.dart';
import 'log_in.dart';

class WebDashboard extends StatefulWidget {
  WebDashboard({Key? key}) : super(key: key);

  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

  String email = "";

  void signOut() async {
    setState(() => _isLoading = true);
    String res = await MAuthMethods().signOut();

    if (res.contains("Success")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } else {
      showSnackBar(context, res);
    }
    setState(() => _isLoading = false);
  }

  Widget _currentPanel = Container(); // default widget

  void changePanel(String panel) {
    setState(() {
      if (panel == "/home") {
        _currentPanel = const Home();
      } else if (panel == "/add_account") {
        _currentPanel = Add_Patrol_Account();
      } else {
        _currentPanel = Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("SentiNex Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              showSnackBar(context, "Profile clicked");
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            color: my_colors.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        changePanel("/home");
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Home'),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        changePanel("/add_account");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Manage Patrol Account',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: signOut,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const Text('Exit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            color: Colors.blue,
            child: _currentPanel,
          )
        ],
      ),
    );
  }
}
