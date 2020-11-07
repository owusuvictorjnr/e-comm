import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:upgradeecomm/address/address_main.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';
import 'cart.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({Key key, this.productId}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  final dBase = FirebaseFirestore.instance.collection("products");
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  // ===> FUNCTION FOR ADDING TO ORDER TO USER <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE CART */
  // ===> FUNCTION FOR ADDING TO CART <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE CART*/
  Future  addToCart(data) {
    String title = data.documents[data]
        .get('Product Title');
    String price = data.documents[data]
        .get('Product Price');
    String thumbnailUrl = data.documents[data]
        .get('thumbnail');
    print("$data");
    print("${db.doc(user.uid).collection("Cart")}");
    print("${data.documents[data].data()}");

    return db.doc(user.uid).collection("Cart").doc(data.documents[data].reference.documentID.toString()).set(
        data.documents[data].data()
    );
  }

  final SnackBar snackbar = SnackBar(content: Text("Added to Cart successfully"));


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Palette.whiteColor ,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Palette.whiteColor,
          title: Text(
            "AMANSAN STORE",
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
              iconSize: 25,
              onPressed: () {
                // _scaffoldKey.currentState.openDrawer();
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
                        builder: (context, snapshot){
                          int totalProduct = 0;
                          if(snapshot.data == null) return spinkit;

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
              padding: EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  FutureBuilder(
                    future: dBase.doc(widget.productId).get(),
                    // ignore: missing_return
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if(snapshot.hasError){
                        return Center(
                          child: Text("something went wrong"),
                        );
                      }
                      if(snapshot.connectionState == ConnectionState.done){
                        // Map<String, dynamic> document = snapshot.data.data();
                        return ListView(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Stack(
                                  children: [
                                    // ===> FOR PRODUCT IMAGE, PRICE AND TITLE <===
                                    Container(
                                      color: Palette.pinkAccent,
                                      height: 300,
                                      width: 400,
                                      child: Image.network(
                                        "${snapshot.data.data()['thumbnail']}",
                                        fit: BoxFit.contain,
                                        height: 300,
                                        width: 200,
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 40,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black38,
                                                Colors.black38,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                        left: 4,
                                        bottom: 5,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${snapshot.data.data()['Product Title']}",
                                              style: TextStyle(
                                                  color: Palette.whiteColor,
                                                  fontSize: 18,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold),),
                                            SizedBox(width: 100,),
                                            Text("${snapshot.data.data()['Product Price']}",
                                              style: TextStyle(
                                                  color: Palette.whiteColor,
                                                  fontSize: 18,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold),),
                                          ],
                                        )
                                    ),
                                  ]
                              ),
                            ),
                            SizedBox(height: 10,),
                            // ===> FOR PRODUCT DESCRIPTION <===
                            Center(
                              child: Text("Product Description".toUpperCase(),
                                style: TextStyle(
                                    color: Palette.pinkAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: 70,
                              width: 200,
                              child: Text("${snapshot.data.data()['Product Description']}",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Palette.blackColor,
                                  fontSize: 14,),),
                            ),
                            SizedBox(height: 5,),

                            // ===> Buy-me Button, Cart, Favorite and Order icon starts here <===
                            Row(
                              children: [
                                Wrap(
                                    direction: Axis.vertical,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Palette.pinkAccent,
                                          borderRadius: BorderRadius.only(topRight:  Radius.circular(15),
                                              bottomLeft:  Radius.circular(15)),
                                        ),
                                        child: InkWell(
                                          // elevation: 3,
                                          // textColor: Palette.whiteColor,
                                          onTap: () {

                                            // ===> SEND USER TO MAIN ADDRESS SCREEN <===
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => AddressMainScreen()),
                                            );
                                            print(
                                                "t"); //Will work on it
                                          },
                                          child: Center(
                                            child: Text(
                                              "Buy Now",
                                              style: TextStyle(
                                                  color: Palette
                                                      .whiteColor),
                                            ),
                                          ),
                                          // color: Palette.mainColor,
                                        ),
                                      ),
                                    ]),
                                SizedBox(
                                  width: 7,
                                ),

                                // ===> SHOPPING BAG ICON STARTS FROM HERE <===
                                IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: Palette.blackColor,
                                    size: 35,
                                  ),

                                  onPressed: (){
                                    addToCart(
                                        snapshot.data
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                  },
                                ),
                                SizedBox(
                                  width: 7,
                                ),

                                // ===> FAVORITING ICON STARTS FROM HERE <===
                                IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Palette.blackColor,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      print("Favorite");
                                    }
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    print('Orders');
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.white,
                                    child: Image.asset("images/order_now.jpg",
                                      fit: BoxFit.cover,),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      }
                      // SHOWING A LOADING SPINNER BY DEFAULT
                      return Center(
                        child: spinkit,
                      );
                    },
                  ),
                ],
              ),
            )
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
