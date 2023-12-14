import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinex/pages/web_dashboard.dart';
import 'package:sentinex/pages/log_in.dart';
import 'package:sentinex/providers/user_provider.dart';
import 'package:sentinex/responsive/mobile_screen_layout.dart';
import 'package:sentinex/responsive/responsive_screen_layout.dart';
import 'package:sentinex/responsive/web_screen_layout.dart';
import 'package:sentinex/utils/my_colors.dart';

import 'utils/string_utils.dart';

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: StringValues().appId,
      messagingSenderId: StringValues().messagingSenderId,
      projectId: StringValues().projectId,
      apiKey: StringValues().apiKey,
      storageBucket: StringValues().storageBucket,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SentiNex',
        theme: ThemeData.dark(useMaterial3: false).copyWith(
          primaryColor: MyColors().secondaryColor,
          scaffoldBackgroundColor: MyColors().primaryColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ResponsiveLayout(
                  webScreenLayout: const WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong!"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: MyColors().primaryColor,
                ),
              );
            }

            return const LogIn();
          },
        ),
      ),
    );
  }
}
