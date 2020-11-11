import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/categories_details/category_products.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';
import 'cart.dart';

class CategoriesScreen extends StatefulWidget {

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //=====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Palette.whiteColor,
          title: Text(
            "CATEGORIES",
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
      drawer: DrawerScreen(),
      body: ListView(
        children: <Widget>[
          Divider(),

          // ===> This is for Female Bags List Tile <===
          ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage("images/female_bag.jpg"),
            ),
            title: Text('Female Bags', style: TextStyle(fontSize: 20),),
            // subtitle: Text('A strong animal'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {

              // ===> SEND USER TO THE ListOfFemaleBagsScreen SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsScreen(category: "female_bags",)),
              );

            },
            // selected: true,
          ),
          Divider(),

          // ===> This is for Male Bags List Tile <===
          ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage("images/male_bag.jpg",),
            ),
            title: Text('Male Bags', style: TextStyle(fontSize: 20),),
            // subtitle: Text('Provider of milk'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {

              // ===> SEND USER TO THE ListOfMaleBagsScreen SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsScreen(category: "male_bags",)),
              );

            },
          ),
          Divider(),

          // ===> This is for Necklaces NECKLACES List Tile <===
          ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage("images/necklace.jpg",),
            ),
            title: Text('Necklaces', style: TextStyle(fontSize: 20),),
            // subtitle: Text('Provider of milk'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {

              // ===> SEND USER TO THE ListOfNecklacesScreen SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsScreen(category:  "necklaces",)),
              );

            },
          ),
          Divider(),


          // ===> This is for Ladies Wear List Tile <===
          ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage("images/ladies_wear.jpg",),
            ),
            title: Text('Ladies Wear', style: TextStyle(fontSize: 20),),
            // subtitle: Text('Provider of milk'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {

              // ===> SEND USER TO THE ListOfLadiesWearScreen SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsScreen(category: "ladies_wear",)),
              );

            },
          ),
          Divider(),

          // ===> This is for CLOTHES List Tile <===
          ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage("images/cloth.jpg",),
            ),
            title: Text('Clothes', style: TextStyle(fontSize: 20),),
            // subtitle: Text('Provides wool'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // ===> SEND USER TO THE ListOfLadiesWearScreen SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsScreen(category: "clothes",)),
              );
            },
          ),
          Divider(),

          // ===> This is for MEN'S SHOES Tile <===
          ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              // backgroundImage: NetworkImage(goatUrl),
              backgroundImage: AssetImage("images/men_shoes.jpg",),
            ),
            title: Text("Men's Shoes", style: TextStyle(fontSize: 20),),
            // subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // ===> SEND USER TO THE ListOfMensShoesScreen SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsScreen(category: "mens_shoes",)),
              );
            },
          ),
          Divider(),

          // ===> This is for FOOD ITEMS Tile <===
          ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              // backgroundImage: NetworkImage(goatUrl),
              backgroundImage: AssetImage("images/food_item.jpg",),
            ),
            title: Text("Food Items", style: TextStyle(fontSize: 20),),
            // subtitle: Text('Some have horns'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // ===> SEND USER TO THE ListOfFoodItemsScreen SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsScreen(category: "food_items",)),
              );
            },
          ),
          Divider(),

        ],
      )
    );
  }
}
