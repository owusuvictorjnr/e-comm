import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/user/role_checker.dart';

import 'config/colors.dart';
import 'constant/botnav.dart';
import 'credentials/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //===> CREATING INSTANCE OF FIREBASE <===
  final FirebaseAuth auth = FirebaseAuth.instance;


  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Palette.pinkAccent,
    size: 50.0,
  );

  @override
  void initState() {
    super.initState();

    // ===> CREATING FUNCTION FOR SHOWING SPLASH <===
    showSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Amansan store".toUpperCase(),
                  style: TextStyle(
                      color: Palette.pinkAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 290,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                        image: AssetImage("images/shopping.jpg"),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Your #1 Online Shop".toUpperCase(),
                    style: TextStyle(
                        color: Palette.pinkAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10,),
                // ===> ADDING SPIN HERE <===
                spinkit,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===> IMPLEMENTING THE showSplash FUNCTION <===
  showSplash() {
    // ===> DURATION OF THE SPLASH SCREEN <===
    Timer((Duration(seconds: 5)), () async {
      // ===> MEANING THE USER IS STILL LOGGED IN <===

      if (auth.currentUser != null) {

        Route route = MaterialPageRoute(builder: (_) =>  BottomNavScreen());
        Navigator.pushReplacement(context, route);
      }

      // ===> MEANING THE USER HAS LOGGED OUT <===
      else {
        Route route = MaterialPageRoute(builder: (_) => LoginScreen());
        Navigator.pushReplacement(context, route);
      }
    });


  }
}
