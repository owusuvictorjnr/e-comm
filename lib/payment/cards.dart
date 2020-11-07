import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';
import 'package:upgradeecomm/user/cart.dart';

class PaymentCards extends StatefulWidget {
  @override
  _PaymentCardsState createState() => _PaymentCardsState();
}

class _PaymentCardsState extends State<PaymentCards> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //=====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  String cardNumber = "54677865023457321";
  String expiryDate = "06/10/22";
  String cardHolderName = "Florence Quansah";
  String cvvCode = '';
  String showBackView = '';
  bool isCvvFocused = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor ,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Palette.whiteColor,
        title: Text(
          "MOBILE PAYMENT",
          style: TextStyle(
              color: Palette.pinkAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2),
        ),
        centerTitle: true,
        leading: Stack(children: [
          CircleButtons(
            iconData: Icons.menu,
            iconSize: 25,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
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
                      builder: (context, snapshot){
                        int totalProduct = 0;

                        if (snapshot.connectionState == ConnectionState.active) {
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
                    )
                ),
              ),
            ),
          ),
        ],

      ),
      key: _scaffoldKey,
      drawer: DrawerScreen(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  height: 50,
                  color: Palette.pinkAccent,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Text(
                        "choose your preferred Payment Method".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),

                // ===> CONTAINER FOR CREDIT CARD <===
                // CreditCardWidget(
                //   height: 180,
                //   width: MediaQuery.of(context).size.width,
                //   cardHolderName: cardHolderName,
                //   cardNumber: cardNumber,
                //   expiryDate: expiryDate,
                //   showBackView: isCvvFocused,
                //   cvvCode: cvvCode,
                //   // cardBgColor: Colors.white,
                //   textStyle: TextStyle(color: Colors.white),
                // ),

                // ===> CONTAINER FOR MTN ACC <===
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFffcc00),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.phone_android,
                                size: 25,),
                              ),
                            ),
                            Text("MTN",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22,),
                        Text("0244 - 567 - 890",
                          style: TextStyle(
                            letterSpacing: 5.0,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 22,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("NAME ON ACCOUNT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[100],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text("FLORENCE ANTWIWAA",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ],
                            ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text("EXPIRES",
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.blue[100],
                            //       ),
                            //     ),
                            //     SizedBox(height: 5,),
                            //     Text("22/08//25",
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.grey[100],
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // ===> CONTAINER FOR TIGO ACC <===
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFe60000),
                            const Color(0xFF0000FF),
                          ],
                          end: Alignment.centerLeft,
                          begin: Alignment.centerRight,
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.phone_android,
                                  size: 25,),
                              ),
                            ),
                            Text("AIRTELTIGO",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22,),
                        Text("0275 - 567 - 890",
                          style: TextStyle(
                            letterSpacing: 5.0,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 22,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("NAME ON ACCOUNT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[100],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text("FLORENCE ANTWIWAA",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ],
                            ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text("EXPIRES",
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.blue[100],
                            //       ),
                            //     ),
                            //     SizedBox(height: 5,),
                            //     Text("22/08//25",
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.grey[100],
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // ===> CONTAINER FOR VODAFONE ACC <===
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFe60000),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.phone_android,
                                  size: 25,),
                              ),
                            ),
                            Text("VODAFONE",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22,),
                        Text("0205 - 567 - 890",
                          style: TextStyle(
                            letterSpacing: 5.0,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 22,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("NAME ON ACCOUNT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[100],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text("FLORENCE ANTWIWAA",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ],
                            ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text("EXPIRES",
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.blue[100],
                            //       ),
                            //     ),
                            //     SizedBox(height: 5,),
                            //     Text("22/08//25",
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.grey[100],
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
