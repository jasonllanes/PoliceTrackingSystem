import 'package:flutter/material.dart';
import 'package:sentinex/pages/log_in.dart';
import 'package:sentinex/responsive/responsive_screen_layout.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        webScreenLayout: LogIn(),
      ),
    );
  }
}
