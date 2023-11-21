import 'package:flutter/material.dart';
import 'package:sentinex/pages/log_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SentiNex',
      theme: ThemeData.light(useMaterial3: false),
      home: LogIn(),
    );
  }
}
