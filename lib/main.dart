import 'package:flutter/material.dart';
import 'package:safe_lock/local_auth.dart';
import 'package:safe_lock/utils.dart';
import 'package:safe_lock/view/splash_screen.dart';
import 'appLock_state.dart';

void main() {
  runApp(
    const AppLock(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Utils.shared.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}
