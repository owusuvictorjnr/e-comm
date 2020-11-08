import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:upgradeecomm/admin/retrieve_users_orders.dart';
import 'package:upgradeecomm/admin/view_contact_us_msg.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/credentials/login.dart';
import 'package:upgradeecomm/services/auth.dart';
import 'category_selecton.dart';

double width;

class AdminDashboard extends StatelessWidget {

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // backgroundColor: Color(0xff453658),
        backgroundColor: Palette.pinkAccent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Palette.whiteColor,
          title: Text(
            "ADMIN DASHBOARD",
            style: TextStyle(
                color: Palette.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2),
          ),
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Palette.pinkAccent,
              backgroundImage: AssetImage("images/shoes.jpeg"),
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              onTap: () {
                // ===> SEND USER TO THE LOGIN SCREEN
                AuthHelper.logOut();

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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    primary: false,
                    crossAxisCount: 2,
                    children: [
                      CardHolder(
                        // icon: IconData(0xe931, fontFamily: 'add'),
                        title: "ADD PRODUCT",
                        onTap: (){
                          // ===> SEND USER TO THE CategorySelectionScreen SCREEN
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CategorySelectionScreen()),
                          );
                        },
                        color: Palette.pinkAccent,

                      ),
                      CardHolder(
                        // icon: IconData(0xe900, fontFamily: 'messages'),
                        title: "QUERIES",
                        onTap: (){
                          // ===> SEND USER TO THE CreateIphonesUploadForm SCREEN
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewContactUsScreen()),
                          );
                        },
                        color: Palette.pinkAccent,

                      ),
                      CardHolder(
                        // icon: IconData(0xe900, fontFamily: 'orders'),
                        title: "ORDERS",
                        onTap: (){
                          // ===> SEND USER TO THE RetrieveUsersOrders SCREEN
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RetrieveUsersOrders()),
                          );
                        },
                        color: Palette.pinkAccent,

                      ),
                      CardHolder(
                        // icon: IconData(0xe900, fontFamily: 'orders'),
                        title: "YET TO DECIDE",
                        onTap: (){
                          // ===> SEND USER TO THE CreateIphonesUploadForm SCREEN
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => CategorySelectionScreen()),
                          // );
                        },
                        color: Palette.pinkAccent,

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
  }
}


// ignore: slash_for_doc_comments
/**********************************************************
    ######## CREATED A CLASS FOR CARDHOLDERS ########
 *********************************************************/
class CardHolder extends StatelessWidget {
  final String title;
  // final IconData icon;
  final Color color;
  final Function onTap;

  const CardHolder(
      {Key key,
        @required this.title,
        // @required this.icon,
        @required this.onTap,
        @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // splashColor: Colors.amber,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Palette.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              // Icon(
              //   icon,
              //   size: 40,
              //   color: color,
              // ),
              // SvgPicture.asset("assets/images/imgplaceholder.png",
              //   height: 128,
              // ),
            ],
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
