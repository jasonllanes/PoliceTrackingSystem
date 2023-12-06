import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/custom_widgets/edit_text_widget.dart';
import 'package:sentinex/utils/my_colors.dart';

import '../resources/auth_methods.dart';
import '../utils/utils.dart';

class Add_Patrol_Account extends StatefulWidget {
  const Add_Patrol_Account({super.key});

  @override
  State<Add_Patrol_Account> createState() => _Add_Patrol_AccountState();
}

class _Add_Patrol_AccountState extends State<Add_Patrol_Account> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

  final TextEditingController _patrolNameController = TextEditingController();
  final TextEditingController _patrolBadgeNumberController =
      TextEditingController();

  void addPatrolAccount() async {
    setState(() {
      _isLoading = true;
    });
    String res = await MAuthMethods().addPatrolAccount(
      name: _patrolNameController.text,
      badge_number: _patrolBadgeNumberController.text,
      deployment: '',
      image_evidence: '',
      location: GeoPoint(0, 0),
      station: '',
      status: '',
      timestamp: Timestamp.now(),
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "Success") {
      showSnackBar(context, "Success");
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  void dispose() {
    _patrolNameController.dispose();
    _patrolBadgeNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Add Patrol Account",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
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
                      "Patrol Name",
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
                      controller: _patrolNameController,
                      decoration: InputDecoration(
                        hintText: "ex: John Doe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
        ],
      ),
    );
  }
}