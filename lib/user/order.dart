import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:upgradeecomm/address/address_main.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/credentials/login.dart';


class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  final db = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;

  bool loading = false;

  signOut() async {
    await auth.signOut();
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ####### FOR removeFromDb ########

      When we swipe an entry from right to left or left to right,
      we will call removeFromDb() and delete the entry from our
      Firestore database.
   ***********************************************************/

  void removeFromDb(documentID) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("Order")
          .doc(documentID)
          .delete();
      // interact();
  }


  void undoDeletion(index, list){
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState((){
      list.insert(index, list);
    });
  }

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Color(0xffffffff),
    size: 50.0,
  );


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Palette.whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Palette.whiteColor,
            title: Text(
              "ORDERS",
              style: TextStyle(
                  color: Palette.pinkAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2),
            ),
            centerTitle: true,
            leading: Stack(children: [
              CircleButtons(
                iconData: EvaIcons.chevronLeftOutline,
                color: Palette.pinkAccent,
                iconSize: 25,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ]),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  // ===> SEND USER TO THE LOGIN SCREEN
                  signOut();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    height: 32,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Palette.whiteColor,
                    ),
                    child: Align(
                      alignment: Alignment.center,

                      // ===> FOR SIGNING ADMIN OUT <===
                      child: Icon(LineAwesomeIcons.alternate_sign_out,
                        color: Palette.pinkAccent,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: loading,
              opacity: 0.5,
              progressIndicator: spinkit,
              color: Palette.pinkAccent,
              child: StreamBuilder<QuerySnapshot>(
                  stream: db.doc(user.uid).collection("Order").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: spinkit,
                      );
                    }
                    return SingleChildScrollView(
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = snapshot.data.docs[index];
                            final documentID = snapshot.data.docs[index].id;
                            final list = snapshot.data.docs;
                            return Dismissible(
                              // Specify the direction to swipe and delete
                              direction: DismissDirection.endToStart,

                              //dismiss when dragged 70% towards the left.
                              dismissThresholds: {
                                // DismissDirection.startToEnd: 0.1,
                                DismissDirection.endToStart: 0.3
                              },
                              key: Key(documentID),
                              onDismissed: (direction) {
                                removeFromDb(documentID);
                                setState(() {
                                  // Remove the item from the data source.
                                  list.removeAt(index);

                                });
                              },
                              // ===> Show a red background as the item is swiped away <===
                              background: Container(
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.centerEnd,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                                height: 140,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(5.0),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 7, left: 1),
                                        child: Column(
                                          children: [
                                            // ===> THIS CONTAINS PRODUCT IMAGE <===
                                            Card(
                                              elevation: 0,
                                              shadowColor: Colors.white,
                                              child: Container(
                                                width: 90,
                                                height: 90,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8.0),
                                                  child: Image.network(
                                                    document.data()['thumbnail'],
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: 10, bottom: 5, left: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                document.data()['Product Title'],
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                document.data()['Product Price'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                // ===> SEND USER TO MAIN ADDRESS SCREEN <===
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => AddressMainScreen()),
                                                );
                                              },
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Palette.pinkAccent,
                                                  borderRadius: BorderRadius.only(topRight:  Radius.circular(15),
                                                      bottomLeft:  Radius.circular(15)),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8, bottom: 8, left: 8, right: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Center(
                                                        child: Text("BUY NOW", style: TextStyle(
                                                          color: Palette.whiteColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   child: Text(
                                            //     document.data()['Mobile Number'],
                                            //     style: TextStyle(
                                            //       color: Colors.black,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    );
                  }),
            ),
          )),
    );
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
}