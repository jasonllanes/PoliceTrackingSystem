import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../utils/my_colors.dart';
import '../utils/utils.dart';

class DeleteAccount extends StatefulWidget {
  String badge_number;
  DeleteAccount({super.key, required this.badge_number});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

  void deleteCurrentAcount() async {
    setState(() {
      _isLoading = true;
    });
    String res = await MAuthMethods().deleteAccount(
      badge_number: widget.badge_number,
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
      title: const Text("Delete Account"),
      content: _isLoading
          ? CircularProgressIndicator()
          : Text("Are you sure you want to delete this account?"),
      actions: [
        TextButton(
          onPressed: () {
            deleteCurrentAcount();
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
