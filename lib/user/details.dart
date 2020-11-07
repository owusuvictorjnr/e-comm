import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'cart.dart';

class DetailsScreen extends StatefulWidget {
  final String productId;

  const DetailsScreen({Key key, this.productId}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String title;
  String price;
  String thumbnailUrl;

  //=====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  // ===> FUNCTION FOR ADDING TO CART <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE CART*/
  Future addToCart(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Cart").doc(widget.productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // ===> FUNCTION FOR ADDING TO FAVORITE <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE FAVORITE */
  Future addToFavorite(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Favorite").doc(widget.productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // ===> FUNCTION FOR ADDING TO ORDER <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE ORDERS*/
  Future addToOrder(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Order").doc(widget.productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.transparent,
              title: Text(
                "PRODUCT DETAIL",
                style: TextStyle(
                    color: Palette.pinkAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.2),
              ),
              centerTitle: true,
              leading: Stack(children: [
                CircleButtons(
                  iconData: Icons.arrow_back,
                  iconSize: 25,
                  onPressed: () {
                   Navigator.of(context).pop();
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
                            stream:
                                db.doc(user.uid).collection("Cart").snapshots(),
                            builder: (context, snapshot) {
                              int totalProduct = 0;

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
          ),
        ],
      ),
    );
  }
}
