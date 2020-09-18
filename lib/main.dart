import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'LogInScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //remove show banner
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

    );
  }
}
