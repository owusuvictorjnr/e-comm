import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/address/address_main.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';
import 'cart.dart';

double width;

class HomeScreen extends StatefulWidget {
  final String productId;

  const HomeScreen({Key key, this.productId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List bannerAdSlider = [
    "images/shoes.jpeg",
    "images/bag1.jpeg",
    "images/necklace.jpeg",
    "images/purse.jpeg",
    "images/bag2.jpeg",
    "images/tshirt.jpg",
    "images/shoe1.jpg",

  ];

  // =====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;

  final dBase = FirebaseFirestore.instance.collection("orders");

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

  Widget _buildCategories({String image, int color}){
    return CircleAvatar(
      maxRadius: 38,
      backgroundColor: Color(color),
      child: Container(
        height: 30,
        child: Image(
          image: AssetImage("images/$image"),
          color: Palette.whiteColor,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    width = MediaQuery.of(context).size.width;

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
              iconData: EvaIcons.menu2Outline,
              iconSize: 25,
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
          ]),
          actions: <Widget>[
            IconButton(icon: Icon(EvaIcons.search,
            size: 30,
            color: Palette.blackColor,),
                onPressed: (){},
            ),
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
            padding: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: ListView(
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                  child: Text("Categories",
                  style: TextStyle(
                    fontSize: 15
                  ),),
                ),

                // ====> THIS IS FOR CATEGORIES <====
                Container(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategories(image: "shirt.png", color: 0xFF3374FF),
                      _buildCategories(image: "dress.png", color: 0xFFF933FF),
                      _buildCategories(image: "necklace.png", color: 0xFFD4AF37),
                      _buildCategories(image: "shoes.png", color: 0xFF90B905),
                      _buildCategories(image: "fashion.png", color: 0xFF04AFEA),
                      _buildCategories(image: "clothes.png", color: 0xFFFB3253),
                      _buildCategories(image: "canned-food.png", color: 0xFF33dcfd),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // ====> SLIDER STARTS FROM HERE <====
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 22 / 10,
                    autoPlay: true,
                  ),
                  items: bannerAdSlider.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image(
                              image: AssetImage(i),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Recent Products",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .limit(12)
                        .orderBy("Published Date", descending: true)
                        .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: spinkit,
                      );
                    }
                    return GridView.builder(
                      physics: ScrollPhysics(), //Added this to make it scrollable
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      // physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10,
                        // childAspectRatio: 1/1.25
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = snapshot.data.documents[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              print(snapshot.data.documents[index].get('Product Title'));

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => ProductDetailScreen(productId: document.id,),
                              //     ));

                              // ====> FOR DIALOG <====
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      // ===> USING MATERIAL TO PREVENT YELLOW LINES IN DIALOG <===
                                      child: Material(
                                        color: Colors.transparent,
                                        type: MaterialType.transparency,
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
                                                        Image.network(
                                                          snapshot.data.documents[index].get('thumbnail'),
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                        ),
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
                                                              print("t"); //Will work on it
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
                                                        print("Cart");
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
                                                              index,
                                                              snapshot.data
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
                                                            index,
                                                            snapshot.data
                                                        );

                                                        addToAdminOrder(
                                                            index,
                                                            snapshot.data
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
                                  });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.network(
                                      snapshot.data.documents[index].get('thumbnail'),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 20,
                                      width: 150,
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
                                        Text(
                                          snapshot.data.documents[index].get('Product Title'),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Palette.whiteColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5,),
                                        // Text(
                                        //   snapshot.data.documents[index].get('Product Price'),
                                        //   overflow: TextOverflow.ellipsis,
                                        //   style: TextStyle(
                                        //       color: Palette.whiteColor,
                                        //       fontSize: 11,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              ],
            ),
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
              Icons.payment,
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