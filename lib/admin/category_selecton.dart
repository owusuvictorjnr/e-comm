import 'package:flutter/material.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/upload_ads/product_upload.dart';
import 'package:upgradeecomm/upload_ads/upload_clothes.dart';
import 'package:upgradeecomm/upload_ads/upload_fooditems.dart';
import 'package:upgradeecomm/upload_ads/upload_ladies_bags.dart';
import 'package:upgradeecomm/upload_ads/upload_ladies_wear.dart';
import 'package:upgradeecomm/upload_ads/upload_male_bags.dart';
import 'package:upgradeecomm/upload_ads/upload_men_shoes.dart';
import 'package:upgradeecomm/upload_ads/upload_necklaces.dart';


class CategorySelectionScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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
            "Select a category".toUpperCase(),
            style: TextStyle(
                color: Palette.pinkAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2),
          ),
          centerTitle: true,
          leading: Stack(children: [
            CircleButtons(
              iconData: Icons.arrow_back,
              color: Palette.pinkAccent,
              iconSize: 25,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ]),
          // actions: <Widget>[
          //   Stack(children: [
          //     CircleButtons(
          //         iconData: Icons.add_circle,
          //         color: Palette.whiteColor,
          //         iconSize: 25,
          //         onPressed: () {
          //           // ===> SEND USER TO THE CART SCREEN
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => CreateProductUploadForm()),
          //           );
          //         }),
          //   ]),
          // ],
        ),
        key: _scaffoldKey,
        // drawer: DrawerScreen(),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: GridView.count(
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          primary: false,
                          children: [
                            /* the card was here but i moved it into a class */

                            // ===> Cardholder for PRODUCT <===
                            CardHolder(
                              onTap: () {
                                // ===> SEND USER TO THE POST CreateProductUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateProductUploadForm()),
                                );
                              },
                              title: "Add Product".toUpperCase(),
                              icon: IconData(0xe900, fontFamily: 'add'),
                              color: Palette.pinkAccent,
                              // color: Color(0xFFff1744),
                            ),

                            // ===> Cardholder for female bags <===
                            CardHolder(
                              onTap: () {

                                // ===> SEND USER TO THE CreateLadiesBagsUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateLadiesBagsUploadForm()),
                                );

                              },
                              title: "Female Bags".toUpperCase(),
                              icon: IconData(0xe900, fontFamily: 'iphone'),
                              color: Color(0xFF91bfff),
                              // color: Color(0xFFff1744),
                            ),

                            // ===> Cardholder for male bags <===
                            CardHolder(
                              onTap: () {

                                // ===> SEND USER TO THE CreateBagsUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateMaleBagsUploadForm()),
                                );

                              },
                              title: "Male Bags".toUpperCase(),
                              icon: IconData(0xe900, fontFamily: 'laptop'),
                              color: Color(0xFFffe291),
                              // color: Color(0xFFff1744),
                            ),

                            // ===> Cardholder for Necklaces <===
                            CardHolder(
                              onTap: () {

                                // ===> SEND USER TO THE CreateNecklaceUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateNecklaceUploadForm()),
                                );

                              },
                              title: "Necklaces".toUpperCase(),
                              icon: IconData(0xe900, fontFamily: 'android'),
                              color: Color(0xFFff91c1),
                              // color: Color(0xFFff1744),
                            ),

                            // ===> Cardholder for Ladies Wear <===
                            CardHolder(
                              onTap: () {
                                // ===> SEND USER TO THE CreateLadiesWearUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateLadiesWearUploadForm()),
                                );
                              },
                              title: "Ladies Wear".toUpperCase(),
                              icon: IconData(0xe900, fontFamily: 'laptop_mac'),
                              // color: Color(0xFF56ccf2),
                              color: Color(0xFF5340de),
                              // color: Color(0xFFff1744),
                            ),

                            // ===> Cardholder for Clothes <===
                            CardHolder(
                              onTap: () {
                                // ===> SEND USER TO THE CreateClothesUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateClothesUploadForm()),
                                );
                              },
                              title: "Clothes".toUpperCase(),
                              icon: IconData(0xe956, fontFamily: 'desk'),
                              color: Color(0xFFA52A2A),
                              // color: Color(0xFFff1744),
                            ),

                            // ===> Cardholder for MEN'S SHOES <===
                            CardHolder(
                              onTap: () {
                                // ===> SEND USER TO THE POST CreateMenShoesUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateMenShoesUploadForm()),
                                );
                              },
                              title: "Men's Shoes".toUpperCase(),
                              icon: IconData(0xe900, fontFamily: 'camera'),
                              color: Palette.pinkAccent,
                              // color: Color(0xFFff1744),
                            ),

                            // ===> Cardholder for FOOD ITEMS <===
                            CardHolder(
                              onTap: () {
                                // ===> SEND USER TO THE POST CreateFoodItemsUploadForm SCREEN
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateFoodItemsUploadForm()),
                                );
                              },
                              title: "Food Items".toUpperCase(),
                              icon: IconData(0xe900, fontFamily: 'camera'),
                              color: Palette.pinkAccent,
                              // color: Color(0xFFff1744),
                            ),
                          ],
                        ),
                      ),
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
}

// ignore: slash_for_doc_comments
/**********************************************************
    ######## CREATED A CLASS FOR CARDHOLDERS ########
 *********************************************************/
class CardHolder extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Function onTap;


  const CardHolder(
      {Key key,
        @required this.title,
        @required this.icon,
        @required this.onTap,
        @required this.color,
      })
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
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Icon(
                icon,
                size: 70,
                color: color,
              ),
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
              Icons.person_outline,
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