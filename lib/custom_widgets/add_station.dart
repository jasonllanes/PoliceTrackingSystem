import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/pages/add_patrol_account.dart';

import '../resources/auth_methods.dart';
import '../utils/my_colors.dart';
import '../utils/utils.dart';

class DialogAddStation extends StatefulWidget {
  const DialogAddStation({key});

  @override
  State<DialogAddStation> createState() => _DialogAddStationState();
}

class _DialogAddStationState extends State<DialogAddStation> {
  final TextEditingController _station = TextEditingController();

  MyColors my_colors = MyColors();
  bool _isLoading = false;

  void updateCurrentStation() async {
    setState(() {
      _isLoading = true;
    });

    String res = await MAuthMethods().updateStation(
      station: _station.text,
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
                    "Station Number",
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
                    controller: _station,
                    decoration: InputDecoration(
                      hintText: "ex: Garfiel, Vesta, etc..",
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
                  onPressed: updateCurrentStation,
                  color: my_colors.primaryColor,
                  minWidth: 300,
                  height: 50,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Add Station",
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
