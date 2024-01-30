import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../utils/my_colors.dart';
import '../utils/utils.dart';

class DeleteStation extends StatefulWidget {
  String station;
  DeleteStation({super.key, required this.station});

  @override
  State<DeleteStation> createState() => _DeleteStationState();
}

class _DeleteStationState extends State<DeleteStation> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

  void deleteCurrentStation() async {
    setState(() {
      _isLoading = true;
    });
    String res = await MAuthMethods().deleteStation(
      station: widget.station,
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
    return AlertDialog(
      title: const Text(
        "Delete Station",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "Are you sure you want to delete this station?",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            deleteCurrentStation();
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No"),
        )
      ],
    );
  }
}
