import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/pages/add_patrol_account.dart';

import '../resources/auth_methods.dart';
import '../utils/my_colors.dart';
import '../utils/utils.dart';

class DialogAddAccount extends StatefulWidget {
  const DialogAddAccount({super.key});

  @override
  State<DialogAddAccount> createState() => _DialogAddAccountState();
}

class _DialogAddAccountState extends State<DialogAddAccount> {
  final TextEditingController _patrolFirstNameController =
      TextEditingController();
  final TextEditingController _patrolLastNameController =
      TextEditingController();
  final TextEditingController _patrolBadgeNumberController =
      TextEditingController();
  var rankSelected = "";

  MyColors my_colors = MyColors();
  bool _isLoading = false;

  // Add_Patrol_Account add_patrol_account = Add_Patrol_Account();

  void addPatrolAccount() async {
    setState(() {
      _isLoading = true;
    });
    String res = await MAuthMethods().addPatrolAccount(
      name: _patrolFirstNameController.text +
          " " +
          _patrolLastNameController.text,
      first_name: _patrolFirstNameController.text,
      last_name: _patrolLastNameController.text,
      rank: rankSelected,
      badge_number: _patrolBadgeNumberController.text,
      deployment: 'Not yet deployed',
      image_evidence: 'No evidence yet',
      location: GeoPoint(0, 0),
      station: 'No station yet',
      status: 'Not yet deployed',
      timestamp: Timestamp.now(),
      lastUpdated: Timestamp.now(),
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "Success") {
      showSnackBar(context, "Success");

      Navigator.pop(context);
    } else {
      showSnackBar(context, res);
      Navigator.pop(context);
    }
  }

  List<String> _list = [
    'SPO1',
    'SPO2',
    'SPO3',
    'SPO4',
    'PO1',
    'PO2',
    'PO3',
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicHeight(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              //Create text fields for 2 fields and a button: Patrol Name, Patrol Badge Number
              children: [
                //Add labels to the text fields
                Container(
                  width: 300,
                  child: Text(
                    "Badge Number",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: MyColors().primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _patrolBadgeNumberController,
                    decoration: InputDecoration(
                      hintText: "ex: 123456",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: Text(
                    "Patrol First Name",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: MyColors().primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _patrolFirstNameController,
                    decoration: InputDecoration(
                      hintText: "ex: John",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: Text(
                    "Patrol Last Name",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: MyColors().primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _patrolLastNameController,
                    decoration: InputDecoration(
                      hintText: "ex: Doe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: Text(
                    "Patrol Rank",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  child: CustomDropdown<String>(
                    closedFillColor: MyColors().primaryColor,
                    expandedFillColor: MyColors().primaryColor,
                    expandedSuffixIcon: const Icon(
                      Icons.arrow_drop_up,
                      color: Colors.white,
                    ),
                    closedSuffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    hintText: 'Select rank',
                    items: _list,

                    // key: _For,
                    onChanged: (value) {
                      setState(() => rankSelected = value);

                      print('changing value to: $value');
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: addPatrolAccount,
                  color: my_colors.primaryColor,
                  minWidth: 300,
                  height: 50,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Add Patrol Account",
                          style: TextStyle(color: Colors.white),
                        ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
