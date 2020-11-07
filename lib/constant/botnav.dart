import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:upgradeecomm/admin/category_selecton.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/pro_tabbar/profile.dart';
import 'package:upgradeecomm/user/cart.dart';
import 'package:upgradeecomm/user/categories_screen.dart';
import 'package:upgradeecomm/user/home_screen.dart';
import 'package:upgradeecomm/user/order.dart';

User user;

class BottomNavScreen extends StatefulWidget {

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    HomeScreen(),
    CategoriesScreen(),
    // CreateUploadFormContainer(),
    CartScreen(),
    AccountScreen(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen(); // Our first view in viewport

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.white,
        elevation: 6,
        backgroundColor: Colors.white,
        child: Container(
          // height: 300,
          child: Stack(
            children: <Widget>[
              Positioned(
                  right: 150,
                  top: 10,
                  child: ClipOval(
                    child: Container(
                      color: Colors.grey,
                      height: 20.0, // height of the button
                      width: 20.0, // width of the button
                    ),
                  )),
              Center(
                  child: ClipOval(
                    child: Container(
                      color: Colors.grey,
                      height: 150.0, // height of the button
                      width: 150.0, // width of the button
                    ),
                  )),
              Center(
                  child: GestureDetector(
                    onTap: () {
                      // ===> SEND USER TO THE ORDERS SCREEN
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrdersScreen()),
                      );
                    },
                    child: ClipOval(
                      child: Container(
                        //color: Colors.green,
                        // width of the button
                        decoration: BoxDecoration(
                            color: Palette.pinkAccent,
                            border: Border.all(
                                color: Colors.white,
                                width: 6.0,
                                style: BorderStyle.solid),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(21.0, 10.0),
                                  blurRadius: 20.0,
                                  spreadRadius: 40.0)
                            ],
                            shape: BoxShape.circle),
                        child: Center(
                          child: Icon(LineAwesomeIcons.first_order,
                            color: Palette.whiteColor,
                              size: 35,
                          ),
                            // child: Text('Orders',
                            //     style:
                            //     TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            // ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        onPressed: () {
          // ===> SEND USER TO THE POST ADVERT SCREEN
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategorySelectionScreen()),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        child: Container(
          color: Colors.transparent,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            HomeScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          size: 35,
                          color: currentTab == 0 ? Colors.black : Palette.txtLightColor,
                        ),

                      ],
                    ),
                  ),
                  MaterialButton(
                    //minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            CategoriesScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          // Icons.list,
                          Icons.category,
                          size: 35,
                          // FlatIcons.menu,
                          color: currentTab == 1 ? Colors.black : Palette.txtLightColor,
                        ),
//                        Text(
//                          ' ',
//                          style: TextStyle(
//                            color: currentTab == 1 ? Colors.blue : Colors.grey,
//                          ),
//                        ),
                      ],
                    ),
                  )
                ],
              ),
              // Right Tab bar icons
              // SizedBox(width: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            CartScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          size: 35,
                          color: currentTab == 2 ? Colors.black : Palette.txtLightColor,
                        ),
//                        Text(
//                          ' ',
//                          style: TextStyle(
//                            color: currentTab == 2 ? Colors.blue : Colors.grey,
//                          ),
//                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    //minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            AccountScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 35,
                          color: currentTab == 3 ? Colors.black : Palette.txtLightColor,
                        ),
//                        Text(
//                          ' ',
//                          style: TextStyle(
//                            color: currentTab == 3 ? Colors.blue : Colors.grey,
//                          ),
//                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
      ),
    );
  }
}