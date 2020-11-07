import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';

import 'cart.dart';

class FavoriteScreen extends StatefulWidget {
  final String productId;

  const FavoriteScreen({Key key, this.productId}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //=====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;
  final productRef = FirebaseFirestore.instance.collection("products");

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
        .collection("Favorite")
        .doc(documentID)
        .delete();
    // interact();
  }

  void undoDeletion(index, list) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      list.insert(index, list);
    });
  }

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
          "FAVORITE",
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

                        if(snapshot.data == null) return spinkit;

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
      key: _scaffoldKey,
      drawer: DrawerScreen(),
      body: FutureBuilder(
        future: db.doc(user.uid).collection("Favorite").get(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              // child: Text("Error: ${snapshot.error}"),
              child: Text("Something went wrong... Try again"),
            );
          }
          // Collection Data ready to display
          if (snapshot.connectionState == ConnectionState.done) {
            // Display the data inside a list view
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
                    //dismiss when dragged 50% towards the left.
                    dismissThresholds: {
                      // DismissDirection.startToEnd: 0.1,
                      DismissDirection.endToStart: 0.7
                    },
                    key: Key(documentID),
                    onDismissed: (direction) {
                      removeFromDb(documentID);
                    },
                    // ===> Show a red background as the item is swiped <===
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
                    child: GestureDetector(
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
                                      onTap: () async {
                                        await addToCart(
                                          snapshot.data.documents[index]
                                              .get('Product Title'),
                                          snapshot.data.documents[index]
                                              .get('Product Price'),
                                          snapshot.data.documents[index]
                                              .get('thumbnail'),
                                        );
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Palette.pinkAccent,
                                            duration: Duration(seconds: 2),
                                            content: Row(
                                              children: [
                                                Icon(Icons.thumb_up, color: Palette.whiteColor,),
                                                SizedBox(width: 8,),
                                                Text("Item added to Cart successfully",
                                                style: TextStyle(
                                                  color: Palette.whiteColor
                                                ),),
                                              ],
                                            ),),
                                        );
                                        print("Favorite");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Palette.pinkAccent,
                                          borderRadius: BorderRadius.only(topRight:  Radius.circular(15),
                                              bottomLeft:  Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8, left: 8, right: 5),
                                          child: Row(
                                            children: [
                                              Text("ADD TO CART", style: TextStyle(
                                                color: Palette.whiteColor,
                                                fontWeight: FontWeight.bold,
                                              ),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
    );
  }
}
