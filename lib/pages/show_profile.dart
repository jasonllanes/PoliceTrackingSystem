import 'package:flutter/material.dart';
import 'package:sentinex/utils/my_colors.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({super.key});

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  //Show authenticated user details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().primaryColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('My Profile'),
            SizedBox(height: 20),
            //Show email
            Text('Email: '),
            SizedBox(height: 20),
            //Show name
            Text('Name: '),
          ],
        ),
      ),
    );
  }
}
