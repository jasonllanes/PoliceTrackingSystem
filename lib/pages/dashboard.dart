import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/resources/auth_methods.dart';
import 'package:sentinex/utils/my_colors.dart';
import 'package:sentinex/utils/utils.dart';

import 'log_in.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

  String email = "";

  @override
  void initState() {
    super.initState();
    getCurrentEmail();
  }

  void getCurrentEmail() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      email = (snap.data() as Map<String, dynamic>)['email'];
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard $email"),
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
                        primary: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        print('Home clicked');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Home'),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        print('Deployments clicked');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Deployments'),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: my_colors.primaryColor,
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
          ),
        ],
      ),
    );
  }
}
