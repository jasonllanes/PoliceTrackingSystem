import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinex/pages/home.dart';
import 'package:sentinex/providers/user_provider.dart';
import 'package:sentinex/resources/auth_methods.dart';
import 'package:sentinex/utils/my_colors.dart';
import 'package:sentinex/utils/utils.dart';
import 'package:sentinex/models/user.dart' as model;

import 'add_dep_and_station.dart';
import 'add_patrol_account.dart';
import 'log_in.dart';
import 'show_profile.dart';

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

  Widget _currentPanel = Container(
    //Showing a big logo in the center
    child: Scaffold(
      backgroundColor: MyColors().oxfordBlue,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/sentinex_logo.png",
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to SentiNex",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Please select a panel from the left",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ); // default widget

  void changePanel(String panel) {
    setState(() {
      if (panel == "/home") {
        _currentPanel = const Home();
      } else if (panel == "/add_account") {
        _currentPanel = Add_Patrol_Account();
      } else if (panel == "/add_dep_and_station") {
        _currentPanel = Add_Dep_And_Station();
      } else if (panel == "/show_profile") {
        _currentPanel = ShowProfile();
      } else {
        _currentPanel = Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    //Return a drawer for mobile view that can be closed and open
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: my_colors.pennBlue,
        title: Text("SentiNex Dashboard"),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                changePanel("/show_profile");
              } else if (value == 'logout') {
                signOut();
                showSnackBar(context, "Logged out");
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Show Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Log Out'),
              ),
            ],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: my_colors.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sentinex",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "Admin",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ListTile(
                      title: const Text("Home"),
                      onTap: () {
                        changePanel("/home");
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text("Manage Patrol Account"),
                      onTap: () {
                        changePanel("/add_account");
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text("Deployments and Stations"),
                      onTap: () {
                        changePanel("/add_dep_and_station");
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: _currentPanel,
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //     title: Text("SentiNex Dashboard"),
    //     actions: [
    //       IconButton(
    //         onPressed: () {
    //           showSnackBar(context, "Profile clicked");
    //         },
    //         icon: const Icon(Icons.person),
    //       ),
    //     ],
    //   ),
    //   body: Row(
    //     children: [
    //       Container(
    //         width: MediaQuery.of(context).size.width * 0.15,
    //         color: my_colors.primaryColor,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: my_colors.primaryColor,
    //                     textStyle: TextStyle(color: my_colors.secondaryColor),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     changePanel("/home");
    //                   },
    //                   child: const Padding(
    //                     padding: EdgeInsets.all(8.0),
    //                     child: Text('Home'),
    //                   ),
    //                 ),
    //                 ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: my_colors.primaryColor,
    //                     textStyle: TextStyle(color: my_colors.secondaryColor),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     changePanel("/add_account");
    //                   },
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       'Manage Patrol Account',
    //                       overflow: TextOverflow.ellipsis,
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                 ),
    //                 ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: my_colors.primaryColor,
    //                     textStyle: TextStyle(color: my_colors.secondaryColor),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     changePanel("/add_dep_and_station");
    //                   },
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       'Deployments and Stations',
    //                       overflow: TextOverflow.ellipsis,
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: my_colors.primaryColor,
    //                     textStyle: TextStyle(color: my_colors.secondaryColor),
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(0),
    //                     ),
    //                   ),
    //                   onPressed: signOut,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: _isLoading
    //                         ? const Center(child: CircularProgressIndicator())
    //                         : const Text('Exit'),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //       Container(
    //         width: MediaQuery.of(context).size.width * 0.85,
    //         color: Colors.blue,
    //         child: _currentPanel,
    //       )
    //     ],
    //   ),
    // );
  }
}
