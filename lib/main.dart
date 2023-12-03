import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/pages/log_in.dart';
import 'package:sentinex/responsive/responsive_screen_layout.dart';
import 'package:sentinex/responsive/web_screen_layout.dart';
import 'package:sentinex/utils/my_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:177303697074:web:4fa7beecbd6c74dc21bbab',
      messagingSenderId: '177303697074',
      projectId: 'cyberwatch-dfd11',
      apiKey: 'AIzaSyCUSrbTWEnhyMM3d5VRDnMQzOO95L_nG-8',
      storageBucket: "cyberwatch-dfd11.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SentiNex',
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        primaryColor: MyColors().secondaryColor,
        scaffoldBackgroundColor: MyColors().primaryColor,
      ),
      home: const ResponsiveLayout(
        webScreenLayout: WebScreenLayout(),
      ),
    );
  }
}
