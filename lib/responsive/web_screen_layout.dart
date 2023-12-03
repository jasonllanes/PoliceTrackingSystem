import 'package:flutter/material.dart';
import 'package:sentinex/pages/log_in.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LogIn(),
    );
  }
}
