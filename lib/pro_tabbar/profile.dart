import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';

import 'edit_profile.dart';
import 'fav_items.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _form = GlobalKey<FormState>();


  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Palette.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Palette.whiteColor,
          title: Text(
            "ACCOUNT DETAILS",
            style: TextStyle(
                color: Palette.pinkAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2),
          ),
          centerTitle: true,
          leading: Stack(children: [
            CircleButtons(
              iconData: EvaIcons.menu2Outline,
              iconSize: 25,
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
          ]),
          actions: <Widget>[],
        ),
        drawer: DrawerScreen(),
        body: SafeArea(
          child: FutureBuilder(
            future: db.doc(user.uid).collection("Profile").limit(1).get(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  // child: Text("Error: ${snapshot.error}"),
                  child: Text("Something went wrong"),
                );
              }
              // ===> Collection Data ready to display <===
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data.docs[index];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // ===> THIS CONTAINS PRODUCT IMAGE <===
                                Container(
                                  width: 110,
                                  height: 110,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.grey[400],
                                      backgroundImage: AssetImage("images/img_placeholder.png"),
                                      child: ClipOval(
                                        child: SizedBox(
                                          height: 150,
                                          width: 150,
                                          child: Image.network(
                                            document.data()['Profile Pic'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document.data()['User Name'],
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Palette.blackColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        document.data()['Phone Number'],
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Palette.blackColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        document.data()['Location'],
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Palette.blackColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      // MaterialButton(
                                      //   shape: RoundedRectangleBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(10)),
                                      //   color: Palette.mainColor,
                                      //   onPressed: () {},
                                      //   child: Text(
                                      //     "Edit Profile",
                                      //     style: TextStyle(
                                      //         color: Palette.whiteColor),
                                      //   ),
                                      // )

                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey[500],
                            ),
                            DefaultTabController(
                                length: 2, // length of tabs
                                initialIndex: 0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        child: TabBar(
                                          labelColor: Palette.pinkAccent,
                                          unselectedLabelColor: Colors.grey[400],
                                          indicatorColor: Palette.pinkAccent,
                                          tabs: [
                                            Tab(text: 'Favorite Items'),
                                            Tab(text: 'Edit Profile'),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          height: 400, //height of TabBarView
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5))),
                                          child: TabBarView(children: <Widget>[
                                            // Container(
                                            //   child: Center(
                                            //     child: Text('Favorite Items',
                                            //         style: TextStyle(
                                            //             fontSize: 22,
                                            //             fontWeight:
                                            //                 FontWeight.bold)),
                                            //   ),
                                            // ),
                                            FavoriteItemsScreen(),
                                            EditProfileScreen(),
                                            // Container(
                                            //   child: Center(
                                            //     child: Text('Edit Profile',
                                            //         style: TextStyle(
                                            //             fontSize: 22,
                                            //             fontWeight:
                                            //                 FontWeight.bold)),
                                            //   ),
                                            // ),
                                          ]))
                                    ])),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
              ;
              return Container(
                child: Center(
                  child: spinkit,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ignore: slash_for_doc_comments
/**********************************************************
    ########## METHOD FOR ON BACK PRESS ##########
 *********************************************************/
Future<bool> _onBackPressed() async {
  var context;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 6,
          backgroundColor: Colors.transparent,
          child: _buildDialogContent(context),
        );
      });
}

Widget _buildDialogContent(BuildContext context) => Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.brown,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 80,
                width: 80,
                child: Icon(
                  MdiIcons.vote,
                  size: 90,
                  color: Colors.brown,
                ),
              ),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Do you want to exit?".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 35, left: 35),
            child: Text(
              "Press No to remain here or Yes to exit",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8),
              RaisedButton(
                color: Colors.white,
                child: Text(
                  "Yes".toUpperCase(),
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  return Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        ],
      ),
    );
