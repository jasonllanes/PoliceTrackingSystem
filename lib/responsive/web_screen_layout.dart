import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinex/pages/web_dashboard.dart';
import 'package:sentinex/providers/user_provider.dart';
import 'package:sentinex/models/user.dart' as model;

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebDashboard(),
    );
  }
}
