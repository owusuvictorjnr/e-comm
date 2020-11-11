import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/admin/dashboard.dart';
import 'package:upgradeecomm/constant/botnav.dart';
import 'package:upgradeecomm/credentials/login.dart';
import 'package:upgradeecomm/services/auth.dart';
import 'package:upgradeecomm/user/home_screen.dart';
import 'home.dart';

// ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
final spinkit = SpinKitHourGlass(
  color: Colors.white,
  size: 50.0,
);

class RoleChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data);
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(snapshot.data.uid).snapshots() ,
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  final user = userDoc.data();
                  if(user['role'] == 'admin') {
                    return AdminDashboard();
                  }else{
                    return BottomNavScreen();
                  }
                }else{
                  return Material(
                    child: Center(child: spinkit,),
                  );
                }
              },
            );
          }
          return LoginScreen();
        }
    );
  }
}