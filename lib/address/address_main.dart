import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';
import 'package:upgradeecomm/user/cart.dart';
import 'add_address.dart';
import 'address.dart';

class AddressMainScreen extends StatefulWidget {
  @override
  _AddressMainScreenState createState() => _AddressMainScreenState();
}

class _AddressMainScreenState extends State<AddressMainScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  //=====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Palette.whiteColor,
        title: Text(
          "ADDRESS",
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

        // ===> FOR TAB BAR NAVIGATION <===
        bottom: TabBar(
          indicatorColor: Palette.pinkAccent,
          unselectedLabelColor: Colors.black,
          labelColor: Palette.pinkAccent,
          controller: tabController,
          tabs: <Widget>[
            Tab(
              child: Row(
                children: [
                  // Icon(
                  //   LineAwesomeIcons.address_book,
                  //   size: 22,
                  //   color: Palette.mainColor,
                  // ),
                  SizedBox(width: 30,),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Address",
                      style: TextStyle(
                        color: Palette.pinkAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Tab(
                  child: Row(
                    children: [
                      // Icon(
                      //   LineAwesomeIcons.plus_circle,
                      //   size: 22,
                      //   color: Palette.mainColor,
                      // ),
                      SizedBox(width: 30,),
                      Align(
                        alignment: Alignment.center,
                        child: Text("New Address",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Palette.pinkAccent,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      key: _scaffoldKey,
      drawer: DrawerScreen(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TabBarView(
            controller: tabController,
            children: [
              AddressScreen(),
              NewAddressScreen(),
            ],
          ),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card();
  }
}

class AddressCard extends StatefulWidget {
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell();
  }
}

class KeyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
