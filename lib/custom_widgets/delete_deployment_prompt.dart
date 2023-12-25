import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../utils/my_colors.dart';
import '../utils/utils.dart';

class DeleteDeployment extends StatefulWidget {
  String deployment;
  DeleteDeployment({super.key, required this.deployment});

  @override
  State<DeleteDeployment> createState() => _DeleteDeploymentState();
}

class _DeleteDeploymentState extends State<DeleteDeployment> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

  void deleteCurrentDeployment() async {
    setState(() {
      _isLoading = true;
    });
    String res = await MAuthMethods().deleteDeployment(
      deployment: widget.deployment,
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
      title: const Text("Delete Deployment"),
      content: _isLoading
          ? CircularProgressIndicator()
          : Text("Are you sure you want to delete this deployment?"),
      actions: [
        TextButton(
          onPressed: () {
            deleteCurrentDeployment();
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
