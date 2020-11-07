import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/address/address_main.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';
import 'package:upgradeecomm/user/cart.dart';
import 'package:carousel_pro/carousel_pro.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  CategoryProductsScreen({Key key, this.category}) : super(key: key);

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState(category: category,);
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final String category;
  String productId;


  _CategoryProductsScreenState({this.category});

  @override
  void initState(){
    super.initState();
    print(this.category);

  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// ===> CREATING INSTANCES OF FIRESTORE <===
  final dB = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance.collection("users");
  final dBase = FirebaseFirestore.instance.collection("orders");


  bool isFavorite = false;


  // ===> FUNCTION FOR ADDING TO CART <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE CART*/
  Future  addToCart(index ,data) {
    String title= data.documents[index]
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
  Future addToFavorite(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Favorite").doc(productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // ===> FUNCTION FOR ADDING TO ORDER TO A USER <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE ORDERS */
  Future addToUserOrder(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Order").doc(productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // ===> FUNCTION FOR ADDING TO ORDER TO ADMIN <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE ORDERS */
  Future addToAdminOrder(title, price, thumbnailUrl) {
    return dBase.doc(productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  checkExistence(DocumentSnapshot snapshot){
    if(!snapshot.exists){
      Future addToAdminOrder(title, price, thumbnailUrl){
        return dBase.doc(productId).set({
          "Product Title": title,
          "Product Price": price,
          "thumbnail": thumbnailUrl,
        });
      }
    }
    else{
      print("Added to Orders already");
    }
  }

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF3F6FB),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Palette.whiteColor,
          title: Text(
            "NECKLACES",
            style: TextStyle(
                color: Palette.pinkAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2),
          ),
          centerTitle: true,
          leading: Stack(children: [
            CircleButtons(
              // iconData: EvaIcons.menu2Outline,
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
            padding: EdgeInsets.only(left: 20, right: 20,),
            child: StreamBuilder(
              stream: dB
                  .collection(category)
                  .limit(10)
                  .orderBy("Published Date", descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return spinkit;
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // SearchScreen(),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          // childAspectRatio: 1/1.25,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = snapshot.data.documents[index];
                          return InkWell(
                            onTap: (){
                              // ===> FOR DIALOG <===
                              return showDialog(
                                  context: context,
                                  builder: (context){
                                    return Center(
                                      // ===> USING MATERIAL TO PREVENT YELLOW LINES IN DIALOG <===
                                      child: Material(
                                        type: MaterialType.transparency,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10, top: 70),
                                          child: ListView(
                                            children: [
                                              Container(
                                                height: 300,
                                                width: 350,
                                                color: Colors.transparent,
                                                child: GridTile(
                                                  child: Container(
                                                    // child: Image.network(
                                                    //   snapshot.data.documents[index].get('thumbnail'),
                                                    //   fit: BoxFit.cover,
                                                    //   width: double.infinity,
                                                    //   height: double.infinity,
                                                    // ),

                                                    // ===> CHANGE TO USE CAROUSEL <===
                                                    child: Carousel(
                                                      boxFit: BoxFit.cover,
                                                      autoplay: false,
                                                      animationCurve: Curves.fastOutSlowIn,
                                                      animationDuration: Duration(milliseconds: 1000),
                                                      dotSize: 6.0,
                                                      dotIncreasedColor: Palette.whiteColor,
                                                      dotBgColor: Colors.transparent,
                                                      dotPosition: DotPosition.bottomCenter,
                                                      dotVerticalPadding: 10.0,
                                                      showIndicator: true,
                                                      indicatorBgPadding: 7.0,
                                                      images: [
                                                        // NetworkImage('https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
                                                        Image.network(
                                                          snapshot.data.documents[index].get('thumbnail'),
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                        ),
                                                        // Image.network(
                                                        //   snapshot.data.documents[index].get('thumbnail1'),
                                                        //   fit: BoxFit.cover,
                                                        //   width: double.infinity,
                                                        //   height: double.infinity,
                                                        // ),
                                                        // Image.network(
                                                        //   snapshot.data.documents[index].get('thumbnail2'),
                                                        //   fit: BoxFit.cover,
                                                        //   width: double.infinity,
                                                        //   height: double.infinity,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  // ===> FOR FOOTER <===
                                                  footer: Container(
                                                    color: Colors.black38,
                                                    child: ListTile(
                                                      leading: Text(
                                                        snapshot.data.documents[index].get("Product Title"),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      trailing: Padding(
                                                        padding: EdgeInsets.only(bottom: 5),
                                                        child: Text(
                                                          snapshot.data.documents[index].get("Product Price"),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Wrap(direction: Axis.vertical, children: [
                                                Flexible(
                                                  child: Expanded(
                                                    child: SingleChildScrollView(
                                                      child: Container(
                                                          width: 340,
                                                          color: Palette.whiteColor,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              ListTile(
                                                                title: Align(
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    "Product Details".toUpperCase(),
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                subtitle: Padding(
                                                                  padding: EdgeInsets.only(top: 5),
                                                                  child: Text(
                                                                    snapshot.data.documents[index].get("Product Description"),
                                                                    style: TextStyle(
                                                                      color: Colors.black87,
                                                                      fontSize: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              SizedBox(
                                                height: 5,
                                              ),

                                              // ===> Buy-me Button, Bags and Favorite icon starts here <===
                                              Container(
                                                color: Palette.whiteColor,
                                                child: Row(
                                                  children: [
                                                    Wrap(direction: Axis.vertical, children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 5),
                                                        child: Container(
                                                          width: 137,
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
                                                      ),
                                                    ]),
                                                    SizedBox(
                                                      width: 3,
                                                    ),

                                                    // ===> SHOPPING BAG ICON STARTS FROM HERE <===
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.shopping_cart,
                                                        color: Palette.blackColor,
                                                        size: 35,
                                                      ),
                                                      onPressed: () async {
                                                        await addToCart(
                                                            index,
                                                            snapshot.data
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),

                                                    // ===> FAVORITING ICON STARTS FROM HERE <===
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.favorite,
                                                          size: 35,
                                                          color: Palette.blackColor,
                                                        ),
                                                        onPressed: () {
                                                          addToFavorite(
                                                            snapshot.data.documents[index]
                                                                .get('Product Title'),
                                                            snapshot.data.documents[index]
                                                                .get('Product Price'),
                                                            snapshot.data.documents[index]
                                                                .get('thumbnail'),
                                                          );
                                                          print("Favorite");
                                                        }
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),

                                                    GestureDetector(
                                                      onTap: () {
                                                        addToUserOrder(
                                                          snapshot.data.documents[index]
                                                              .get('Product Title'),
                                                          snapshot.data.documents[index]
                                                              .get('Product Price'),
                                                          snapshot.data.documents[index]
                                                              .get('thumbnail'),
                                                        );

                                                        addToAdminOrder(
                                                          snapshot.data.documents[index]
                                                              .get('Product Title'),
                                                          snapshot.data.documents[index]
                                                              .get('Product Price'),
                                                          snapshot.data.documents[index]
                                                              .get('thumbnail'),
                                                        );
                                                        print('Orders');

                                                      },
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        // color: Colors.white,
                                                        child: Image.asset("images/order_now.jpg",
                                                          fit: BoxFit.cover,),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    // ===> CANCEL ICON STARTS FROM HERE <===
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 35,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop(true);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              );
                              print(snapshot.data.documents[index].get('Product Title'));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 205,
                                    child: AspectRatio(
                                      aspectRatio: 0.83,
                                      child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Card(
                                              elevation: 5,
                                              child: Container(
                                                height: 300,
                                                width: 370,
                                                color: Color(0xFFF3F6FB),
                                                child: Image.network(
                                                  snapshot.data.documents[index].get('thumbnail'),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 25,
                                      width: 300,
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
                                    child: Text(
                                      snapshot.data.documents[index].get('Product Title'),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Palette.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
            ),
          ),
        )
    );
  }
}