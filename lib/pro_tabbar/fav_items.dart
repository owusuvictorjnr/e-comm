import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/address/address_main.dart';
import 'package:upgradeecomm/config/colors.dart';

class FavoriteItemsScreen extends StatefulWidget {
  final String productId;

  const FavoriteItemsScreen({Key key, this.productId}) : super(key: key);

  @override
  _FavoriteItemsScreenState createState() => _FavoriteItemsScreenState();
}

class _FavoriteItemsScreenState extends State<FavoriteItemsScreen> {

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
  Future  addToCart(index ,data) {
    String title = data.documents[index]
        .get('Product Title');
    String price = data.documents[index]
        .get('Product Price');
    String thumbnailUrl = data.documents[index]
        .get('thumbnail');
    print("$data");
    print("${db.doc(user.uid).collection("Cart")}");
    print("${data.documents[index].data()}");

    return db.doc(user.uid).collection("Cart").doc(data.documents[index].reference.documentID.toString()).set(
        data.documents[index].data()
    );
  }

  // ===> FUNCTION FOR ADDING TO FAVORITE <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE FAVORITE */
  Future addToFavorite(index ,data) {
    String title = data.documents[index]
        .get('Product Title');
    String price = data.documents[index]
        .get('Product Price');
    String thumbnailUrl = data.documents[index]
        .get('thumbnail');
    print("$data");
    print("${db.doc(user.uid).collection("Favorite")}");
    print("${data.documents[index].data()}");

    return db.doc(user.uid).collection("Favorite").doc(data.documents[index].reference.documentID.toString()).set(
        data.documents[index].data()
    );
  }

  // ===> FUNCTION FOR ADDING TO ORDER TO A USER <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE ORDERS */
  Future addToUserOrder(index ,data) {
    String title = data.documents[index]
        .get('Product Title');
    String price = data.documents[index]
        .get('Product Price');
    String thumbnailUrl = data.documents[index]
        .get('thumbnail');
    print("$data");
    print("${db.doc(user.uid).collection("Order")}");
    print("${data.documents[index].data()}");

    return db.doc(user.uid).collection("Order").doc(data.documents[index].reference.documentID.toString()).set(
        data.documents[index].data()
    );
  }

  // ===> FUNCTION FOR ADDING TO ORDER TO ADMIN <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE ORDERS */
  Future addToAdminOrder(index ,data) {
    String title = data.documents[index]
        .get('Product Title');
    String price = data.documents[index]
        .get('Product Price');
    String thumbnailUrl = data.documents[index]
        .get('thumbnail');
    print("$data");
    print("${db.doc(user.uid).collection("order")}");
    print("${data.documents[index].data()}");

    return FirebaseFirestore.instance.collection("orders").doc(data.documents[index].reference.documentID.toString()).set(
        data.documents[index].data()
    );
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
      body: FutureBuilder(
        future: db.doc(user.uid).collection("Favorite").get(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              // child: Text("Error: ${snapshot.error}"),
              child: Text("Something went wrong"),
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
                                    // ===> Buy-me Button, Bags and Favorite icon starts here <===
                                    Container(
                                      color: Palette.whiteColor,
                                      child: Row(
                                        children: [
                                          Wrap(direction: Axis.vertical, children: [
                                            GestureDetector(
                                              onTap: (){
                                                // ===> SEND USER TO MAIN ADDRESS SCREEN <===
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => AddressMainScreen()),
                                                );
                                              },
                                              child: Container(
                                                width: 135,
                                                decoration: BoxDecoration(
                                                  color: Palette.pinkAccent,
                                                  borderRadius: BorderRadius.only(topRight:  Radius.circular(15),
                                                      bottomLeft:  Radius.circular(15)),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8, bottom: 8, left: 5, right: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Center(
                                                        child: Text("CHECKOUT", style: TextStyle(
                                                          color: Palette.whiteColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          // SizedBox(
                                          //   width: 0,
                                          // ),
                                          //
                                          // // ===> SHOPPING BAG ICON STARTS FROM HERE <===
                                          // IconButton(
                                          //   icon: Icon(
                                          //     Icons.shopping_cart,
                                          //     color: Palette.blackColor,
                                          //     size: 35,
                                          //   ),
                                          //   onPressed: () async {
                                          //     await addToCart(
                                          //         index,
                                          //         snapshot.data
                                          //     );
                                          //     print("Cart");
                                          //   },
                                          // ),
                                          // SizedBox(
                                          //   width: 0,
                                          // ),
                                          //
                                          // // ===> FAVORITING ICON STARTS FROM HERE <===
                                          // IconButton(
                                          //     icon: Icon(
                                          //       Icons.favorite,
                                          //       size: 35,
                                          //       color: Palette.blackColor,
                                          //     ),
                                          //     onPressed: () {
                                          //       addToFavorite(
                                          //           index,
                                          //           snapshot.data
                                          //       );
                                          //       print("Favorite");
                                          //     }
                                          // ),
                                          // SizedBox(
                                          //   width: 0,
                                          // ),
                                          //
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     addToUserOrder(
                                          //         index,
                                          //         snapshot.data
                                          //     );
                                          //
                                          //     addToAdminOrder(
                                          //         index,
                                          //         snapshot.data
                                          //     );
                                          //     print('Orders');
                                          //
                                          //   },
                                          //   child: Container(
                                          //     height: 35,
                                          //     width: 35,
                                          //     // color: Colors.white,
                                          //     child: Image.asset("images/order_now.jpg",
                                          //       fit: BoxFit.cover,),
                                          //   ),
                                          // ),

                                        ],
                                      ),
                                    )
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
