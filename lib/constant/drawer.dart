import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/credentials/login.dart';
import 'package:upgradeecomm/user/cart.dart';
import 'package:upgradeecomm/user/contact_us.dart';
import 'package:upgradeecomm/user/fav.dart';
import 'package:upgradeecomm/user/order.dart';

import 'botnav.dart';

class DrawerScreen extends StatelessWidget {

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;


  // ===> THIS IS FOR SIGN OUT <===
  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            decoration: BoxDecoration(
                color: Palette.pinkAccent,
                image: DecorationImage(
                  image: AssetImage("images/mall.jpeg"),
                  fit: BoxFit.cover,
                )
            ),
            child: Column(
              children: [
                Container(
                  child: Material(
                    borderRadius: BorderRadius.circular(80),
                    elevation: 8,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("images/mall.jpeg"),
                        backgroundColor: Palette.whiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 1),
            decoration: BoxDecoration(color: Palette.whiteColor),
            child: Column(
              children: [

                // ===> FOR HOME <===
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.black54,
                  ),
                  // ===> Added Align to help remove the space between leading and title
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      "Home",
                      style: TextStyle(
                        color: Palette.blackColor,
                      ),
                    ),
                  ),
                  onTap: (){
                    // ===> SEND USER TO THE HOME SCREEN
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavScreen()),
                    );
                  },
                ),

                Divider(
                  height: 1,
                  color: Colors.black12,
                  thickness: 1,
                ),

                // ===> FOR ORDERS <===
                ListTile(
                  leading: Icon(
                    Icons.shopping_basket,
                    color: Colors.black54,
                  ),
                  // ===> Added Align to help remove the space between leading and title
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      "My Orders",
                      style: TextStyle(
                        color: Palette.blackColor,
                      ),
                    ),
                  ),
                  onTap: (){
                    // ===> SEND USER TO THE HOME SCREEN
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrdersScreen()),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.black12,
                  thickness: 1,
                ),

                // ===> FOR CART <===
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.black54,
                  ),
                  // ===> Added Align to help remove the space between leading and title
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      "My Cart",
                      style: TextStyle(
                        color: Palette.blackColor,
                      ),
                    ),
                  ),
                  onTap: (){
                    // ===> SEND USER TO THE HOME SCREEN
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.black12,
                  thickness: 1,
                ),

                // ===> FOR FAVORITE <===
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.black54,
                  ),

                  // ===> Added Align to help remove the space between leading and title
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      "Favorite",
                      style: TextStyle(
                        color: Palette.blackColor,
                      ),
                    ),
                  ),
                  onTap: (){
                    // ===> SEND USER TO THE FAVOURITE SCREEN
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoriteScreen()),
                    );
                  },
                ),

                Divider(
                  height: 1,
                  color: Colors.black12,
                  thickness: 1,
                ),

                // ===> SEND USER TO THE CONTACT US SCREEN <===

                ListTile(
                  leading: Icon(
                    LineAwesomeIcons.mail_bulk,
                    color: Colors.black54,
                  ),
                  // ===> Added Align to help remove the space between leading and title
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      "Contact Us",
                      style: TextStyle(
                        color: Palette.blackColor,
                      ),
                    ),
                  ),
                  onTap: (){
                    // ===> SEND USER TO THE CONTACT US SCREEN

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUsScreen()),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.black12,
                  thickness: 1,
                ),

                // ===> SEND USER TO THE HOME SCREEN AFTER LOGOUT <===

                ListTile(
                  leading: Icon(
                    LineAwesomeIcons.alternate_sign_out,
                    color: Colors.black54,
                  ),
                  // ===> Added Align to help remove the space between leading and title
                  title: Align(
                    alignment: Alignment(-1.2, 0),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Palette.blackColor,
                      ),
                    ),
                  ),
                  onTap: (){
                    // ===> SEND USER TO THE LOGIN SCREEN
                    signOut();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.black12,
                  thickness: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
