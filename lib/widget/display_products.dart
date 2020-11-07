import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/address/address_main.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/botnav.dart';


class DisplayProducts extends StatefulWidget {
  final String productId;

  const DisplayProducts({Key key, this.productId}) : super(key: key);

  @override
  _DisplayProductsState createState() => _DisplayProductsState();
}

class _DisplayProductsState extends State<DisplayProducts> {
  final GlobalKey<FormState> _mobiileKey = GlobalKey<FormState>();

  List<String> images = [
    "asset/images/iphone1.jpg",
    "asset/images/iphone2.jpg",
    "asset/images/iphones.jpg",
    "asset/images/macbook.jpg",
    "asset/images/macbook1.jpg",
    "asset/images/macbook3.jpg",
    "asset/images/android.jpg",
    "asset/images/android1.jpg",
    "asset/images/android2.jpg",
    "asset/images/camera.jpg",
    "asset/images/camera1.jpg",
    "asset/images/camera2.jpg",
  ];

  String title;
  String price;
  String mobile;
  String thumbnailUrl;
  bool loading = false;

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection("users");

  final dBase = FirebaseFirestore.instance.collection("orders");

  TextEditingController mobileController = TextEditingController();

  //=====> FOR CLEAR FORM <=====
  clearForm() {
    setState(() {
      mobileController.clear();
    });
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING PHONE NUMBER #######
   ****************************************************************/
  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### CHECKING IF FORM IS VALID BEFORE SUBMITTING ######
   *******************************************************************/
  bool validateAndSave(){
    final form = _mobiileKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  validateAndSubmit (title, price, thumbnailUrl, mobile) async {
    if (validateAndSave()){
      // ===> SETTING CIRCULAR PROGRESS BAR TO TRUE <===
      setState(() {
        loading = true;
      });

      try{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavScreen()));

        print(title);

        // ===> This helps to get the uid in the dB <===
        User user = auth.currentUser;

        // ===> Am using the uid to make data retrieving easier <===
        await db.doc(widget.productId).set({
          'uid': user.uid,
          "Product Title": title,
          "Product Price": price,
          "Mobile Number": mobile,
          "thumbnail": thumbnailUrl,
          "Published Date": DateTime.now(),
        }).then((value) => null);

      } catch (e){

      }
    }
  }


  bool isFavorite = false;
  bool isAddedToCart = false;

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  //=====> FOR INSTANCES OF FIREBASE <=====
  User user = FirebaseAuth.instance.currentUser;

  // ===> FUNCTION FOR ADDING TO CART <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE CART*/
  Future addToCart(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Cart").doc(widget.productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // ===> FUNCTION FOR ADDING TO FAVORITE <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE FAVORITE */
  Future addToFavorite(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Favorite").doc(widget.productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // ===> FUNCTION FOR ADDING TO ORDER TO A USER <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE ORDERS */
  Future addToUserOrder(title, price, thumbnailUrl) {
    return db.doc(user.uid).collection("Order").doc(widget.productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // ===> FUNCTION FOR ADDING TO ORDER TO ADMIN <===

  /* I CREATED A SUB-COLLECTION WITHIN THE USERS COLLECTION TO STORE ORDERS */
  Future addToAdminOrder(title, price, thumbnailUrl) {
    return dBase.doc(widget.productId).set({
      "Product Title": title,
      "Product Price": price,
      "thumbnail": thumbnailUrl,
    });
  }

  // Future addToOrder(title, price, thumbnailUrl) {
  //   return dBase.doc(user.uid).collection("Orders").doc(widget.productId).set({
  //     "Product Title": title,
  //     "Product Price": price,
  //     "thumbnail": thumbnailUrl,
  //     // "Mobile Number": mobile,
  //   });
  // }

  checkProductInCart(String productId, context){

  }

  alertDialog(){
    return AlertDialog(
      content: Text("Item Added to Cart already"),
      actions: <Widget>[
        FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(true);
            }
        )
      ],
    );
  }


  // ===> SHOW SNACK BAR TO THE USER AFTER ADDING PRODUCT TO CART <===
  final SnackBar snackBar =
      SnackBar(content: Text("Added to Cart Successfully"));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // ====> Retrieve items by published date, show in descending order,
      // and limit it to 12 products <====

      stream: FirebaseFirestore.instance
          .collection("products")
          .limit(12)
          .orderBy("Published Date", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: spinkit,
          );
        }
        return Expanded(
          child: GridView.builder(
            physics: ScrollPhysics(), //Added this to make it scrollable
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print(snapshot.data.documents[index].get('Product Title'));

                  // ===> FOR DIALOG <===
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          // ===> USING MATERIAL TO PREVENT YELLOW LINES IN DIALOG <===
                          child: Material(
                            // color: Colors.transparent,
                            type: MaterialType.transparency,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Palette.whiteColor),
                                padding: EdgeInsets.all(15),
                                // width: MediaQuery.of(context).size.width * 0.7,
                                width: 310,
                                height: 477,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    // ===> FOR PRODUCT IMAGE <===
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        snapshot.data.documents[index]
                                            .get('thumbnail'),
                                        fit: BoxFit.cover,
                                        height: 200,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),

                                    // ===> FOR PRODUCT PRICE AND TITLE <===
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.documents[index]
                                              .get('Product Title'),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Palette.blackColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(
                                          snapshot.data.documents[index]
                                              .get('Product Price'),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Palette.blackColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    // ===> FOR PRODUCT DESCRIPTION <===
                                    Container(
                                      height: 130,
                                      child: SingleChildScrollView(
                                          child: Text(
                                              snapshot.data.documents[index].get('Product Description'),
                                            style: TextStyle(
                                              color: Palette.blackColor,
                                            ),
                                            textAlign: TextAlign.justify,
                                          )
                                      ),
                                    ),

                                    SizedBox(height: 10,),

                                    // ===> Buy-me Button, Cart, Favorite and Order icon starts here <===
                                    Row(
                                      children: [
                                        Wrap(
                                            direction: Axis.vertical,
                                            children: [
                                              Container(
                                                width: 110,
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
                                          onPressed: () async {
                                            await addToCart(
                                              snapshot.data.documents[index]
                                                  .get('Product Title'),
                                              snapshot.data.documents[index]
                                                  .get('Product Price'),
                                              snapshot.data.documents[index]
                                                  .get('thumbnail'),
                                            );
                                            print("Cart");
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
                                          width: 7,
                                        ),

                                        // ===> ORDER ICON STARTS FROM HERE <===
                                        // IconButton(
                                        //   icon: Icon(
                                        //     LineAwesomeIcons.first_order,
                                        //     color: Palette.blackColor,
                                        //     size: 35,
                                        //   ),
                                        //   onPressed: () {
                                        //     // ===> SEND USER TO ORDER SCREEN <===
                                        //     addToOrder(
                                        //       snapshot.data.documents[index]
                                        //           .get('Product Title'),
                                        //       snapshot.data.documents[index]
                                        //           .get('Product Price'),
                                        //       snapshot.data.documents[index]
                                        //           .get('thumbnail'),
                                        //     );
                                        //     print('Orders');
                                        //
                                        //   },
                                        // ),

                                        // ===> ORDER IMAGE STARTS FROM HERE <===
                                        GestureDetector(
                                          onTap: (){
                                            // ===> RETRIEVE THESE DETAILS FROM ORDERS COLLECTION <===
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

                                           /*
                                           *
                                           *  // return showDialog(
                                            //   context: context,
                                            //   builder: (context){
                                            //     return Center(
                                            //       child: Material(
                                            //         child: Padding(
                                            //           padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                                            //           child: Container(
                                            //             decoration: BoxDecoration(
                                            //                 borderRadius: BorderRadius.circular(10)
                                            //             ),
                                            //             height: 160,
                                            //             width: 250,
                                            //             child: Column(
                                            //               children: [
                                            //                 Container(
                                            //                   decoration: BoxDecoration(
                                            //                     borderRadius: BorderRadius.circular(10)
                                            //                   ),
                                            //                   child: Form(
                                            //                     key: _mobiileKey,
                                            //                     autovalidate: _autoValidate,
                                            //                     child: TextFormField(
                                            //                       maxLines: 1,
                                            //                       autofocus: false,
                                            //                       keyboardType: TextInputType.phone,
                                            //                       onChanged: (value) {
                                            //                         mobile = value;
                                            //                       },
                                            //                       validator: validateMobile,
                                            //                       onSaved: (value) => mobile = value,
                                            //                       style: TextStyle(
                                            //                         color: Colors.black,
                                            //                       ),
                                            //                       decoration: InputDecoration(
                                            //                           focusedBorder: OutlineInputBorder(
                                            //                             borderRadius: BorderRadius.all(Radius.circular(4)),
                                            //                             borderSide: BorderSide(width: 1,color: Palette.mainColor),
                                            //                           ),
                                            //                           border: OutlineInputBorder(),
                                            //                           labelText: 'Phone Number',
                                            //                           prefixIcon: Icon(Icons.phone_android,
                                            //                             color: Colors.black,),
                                            //                           labelStyle: TextStyle(
                                            //                             fontSize: 15,
                                            //                             color: Colors.black,
                                            //                           )
                                            //                       ),
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //                 Padding(
                                            //                   padding: EdgeInsets.only(top: 10),
                                            //                   child: MaterialButton(
                                            //                     onPressed: (){
                                            //                     validateAndSubmit(title, price, thumbnailUrl, mobile);},
                                            //                     child: Text('PROCEED TO ORDER',
                                            //                       style: TextStyle(
                                            //                         fontSize: 15,
                                            //                         fontWeight: FontWeight.bold,
                                            //                       ),
                                            //                     ),
                                            //                     // color: Color(0xffff2d55),
                                            //                     color: Color(0xff706695),
                                            //                     elevation: 0,
                                            //                     minWidth: 400,
                                            //                     height: 50,
                                            //                     textColor: Colors.white,
                                            //                     shape: RoundedRectangleBorder(
                                            //                         borderRadius: BorderRadius.circular(10)
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ),
                                            //         )
                                            //       )
                                            //     );
                                            //   }
                                            // );
                                           *
                                           * */
                                            print('Orders');
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            color: Colors.white,
                                            child: Image.asset("asset/images/order_now.jpg",
                                            fit: BoxFit.cover,),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });

                  // ===> SEND USER TO THE DETAILS SCREEN <===
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DetailsScreen()),
                  // );

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
                        child: Text(
                          snapshot.data.documents[index].get('Product Title'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Palette.whiteColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ignore: slash_for_doc_comments
/**********************************************************
    ######## CREATED A CLASS FOR CARDHOLDERS ########
 *********************************************************/
class CardHolder extends StatelessWidget {
  final String title;
  final Icon icon;
  final Color color;
  final Function onTap;

  const CardHolder(
      {Key key,
      @required this.title,
      @required this.icon,
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
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              // Icon(
              //   IconS,
              //   size: 70,
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


