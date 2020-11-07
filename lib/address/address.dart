import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/payment/cards.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // =====> FOR INSTANCES OF FIREBASE <=====
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;
  final productRef = FirebaseFirestore.instance.collection("products");

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

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
        .collection("Address")
        .doc(documentID)
        .delete();
    // interact();
  }

  // ===> FOR DISPLAYING NO ADDRESS CONTAINER <===

  noAddressContainer() {
    return Card(
      elevation: 5,
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No Address Added yet"),
            Text("Add one for easy delivery")
          ],
        ),
      ),
    );
  }

  int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  setSelectedIndex(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===> THIS IS FOR FAB <===
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Add your onPressed code here!
      //   },
      //   label: Text('Proceed'),
      //   icon: Icon(Icons.thumb_up),
      //   backgroundColor: Palette.mainColor,
      // ),
      backgroundColor: Palette.whiteColor,
      body: SafeArea(
        child: FutureBuilder(
          future: db
              .doc(user.uid)
              .collection("Address")
              .limit(1)
              .orderBy("Published Date", descending: true)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: spinkit,
              );
            }
            // ===> Collection Data ready to display <===
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
                      return Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                            height: 50,
                            color: Palette.pinkAccent,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Center(
                                child: Text(
                                  "CONFIRM YOUR ADDRESS OR ADD NEW ONE".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),

                          Dismissible(
                            // Specify the direction to swipe and delete
                            direction: DismissDirection.endToStart,
                            //dismiss when dragged 50% towards the left.
                            dismissThresholds: {
                              // DismissDirection.startToEnd: 0.1,
                              DismissDirection.endToStart: 0.5
                            },
                            key: Key(documentID),
                            onDismissed: (direction) {
                              removeFromDb(documentID);
                            },
                            // ===> Show a red background as the item is swiped <===
                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  //==> change bg color when index is selected ==>
                                  color: Palette.whiteColor,
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  height: 168,
                                  width: double.maxFinite,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: 10, left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                document.data()['Full Name'],
                                                style: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle.double,
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    document.data()['Phone Number'],
                                                    style: TextStyle(
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .double,
                                                      color: Colors.black87,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                document.data()['Area Name'],
                                                style: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle.double,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                document.data()['GPS Address'],
                                                style: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle.double,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 130,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Palette.pinkAccent,
                                                    borderRadius: BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(15)),
                                                  ),
                                                  child: InkWell(
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          // ===> SEND USER TO MOBILE PAYMENT SCREEN <===
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => PaymentCards()),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Proceed".toUpperCase(),
                                                          style: TextStyle(
                                                            color: Palette.whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // color: Palette.mainColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }
            return Container(
              child: Center(
                child: spinkit,
              ),
            );
          },
        ),
      ),
    );
  }
}
