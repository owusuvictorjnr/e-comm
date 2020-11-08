import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/user/cart.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  // =====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;
  // final productRef = FirebaseFirestore.instance.collection("products");

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Palette.whiteColor,
        title: Text(
          "CHECKOUT",
          style: TextStyle(
              color: Palette.pinkAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2),
        ),
        centerTitle: true,
        leading: Stack(children: [
          CircleButtons(
            iconData: EvaIcons.arrowBackOutline,
            iconSize: 25,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ]),
        actions: <Widget>[
          InkWell(
            onTap: () {
              // ===> SEND USER TO CART SCREEN <===
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: 32,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Palette.pinkAccent,
                ),
                child: Align(
                    alignment: Alignment.center,

                    // ===> THE STREAM IS FOR +/- IN  THE CART ITEM COUNT <===
                    child: StreamBuilder(
                      stream: db.doc(user.uid).collection("Cart").snapshots(),
                      builder: (context, snapshot) {
                        int totalProduct = 0;

                        if (snapshot.data == null) return spinkit;

                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          List _documents = snapshot.data.docs;
                          totalProduct = _documents.length;
                        }

                        return Text(
                          "$totalProduct" ?? "0",
                          style: TextStyle(
                            color: Palette.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}