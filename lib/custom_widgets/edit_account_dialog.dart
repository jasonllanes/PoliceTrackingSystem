import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../utils/my_colors.dart';
import '../utils/utils.dart';

class EditAccountDialog extends StatefulWidget {
  String image_link;
  String badge_number;
  String first_name;
  String last_name;
  String rank;
  EditAccountDialog(
      {super.key,
      required this.image_link,
      required this.badge_number,
      required this.first_name,
      required this.last_name,
      required this.rank});

  @override
  State<EditAccountDialog> createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends State<EditAccountDialog> {
  final TextEditingController _patrolFirstNameController =
      TextEditingController();
  final TextEditingController _patrolLastNameController =
      TextEditingController();
  final TextEditingController _patrolBadgeNumberController =
      TextEditingController();
  var image_url = "";
  var rankSelected = "";

  MyColors my_colors = MyColors();
  bool _isLoading = false;

  // Add_Patrol_Account add_patrol_account = Add_Patrol_Account();

  void updateCurrentPatrolAccount() async {
    setState(() {
      _isLoading = true;
    });
    String res = await MAuthMethods().updatePatrolAccount(
      name: _patrolFirstNameController.text +
          " " +
          _patrolLastNameController.text,
      first_name: _patrolFirstNameController.text,
      last_name: _patrolLastNameController.text,
      rank: rankSelected,
      badge_number: _patrolBadgeNumberController.text,
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
    'Constable',
    'Sergeant',
    'Staff Sergeant',
    'Inspector',
    'Superintendent',
    'Assistant Commissioner',
    'Deputy Commissioner',
    'Commissioner',
    'Deputy Chief',
    'Chief',
    'Deputy Minister',
    'Minister',
    'Deputy Premier',
    'Premier',
    'Prime Minister',
  ];

  @override
  void initState() {
    _patrolFirstNameController.text = widget.first_name;
    _patrolLastNameController.text = widget.last_name;
    _patrolBadgeNumberController.text = widget.badge_number;
    rankSelected = widget.rank;
    image_url = widget.image_link.toString();
    print("The link is: " + image_url);
    super.initState();
  }

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                //Create text fields for 2 fields and a button: Patrol Name, Patrol Badge Number
                children: [
                  //Show an image coming from firebase storage
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(image_url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                      initialItem: rankSelected,
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
                    onPressed: () {
                      updateCurrentPatrolAccount();
                    },
                    color: my_colors.primaryColor,
                    minWidth: 300,
                    height: 50,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Update Patrol Account",
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
      ),
    );
  }
}
