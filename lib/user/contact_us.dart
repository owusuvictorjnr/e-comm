import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/botnav.dart';
import 'package:upgradeecomm/constant/circle_buttons.dart';
import 'package:upgradeecomm/constant/drawer.dart';
import 'cart.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String fname;
  String email;
  String mobile;
  String message;
  bool autovalidate = false;
  bool loading = false;

  // ===> Text Input Controllers <===
  TextEditingController fnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();


  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  clearForm() {
    setState(() {
      fnameController.clear();
      mobileController.clear();
      emailController.clear();
      messageController.clear();
    });
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING USER NAME #######
   ****************************************************************/
  String validateFName(String value){
    // Pattern pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}'
    //     r'\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = RegExp(pattern);
    if (value.isEmpty) return 'Full Name is required';
    // if (!regex.hasMatch(value))
    //   return 'Enter a valid Full Name';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING PHONE NUMBER #######
   ****************************************************************/

  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING BOTH LOGIN & REGISTER EMAIL #######
   ****************************************************************/
  String validateEmail(String value){
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}'
        r'\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) return 'Email Address is required';
    if (!regex.hasMatch(value))
      return 'Enter a valid Email Address';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### CHECKING IF FORM IS VALID BEFORE SUBMITTING ######
   *******************************************************************/
  bool validateAndSave(){
    final form = _form.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
                     ##### FOR VALIDATING MESSAGE ######
   *******************************************************************/
  String validateMessage (String value){
    // Pattern pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}'
    //     r'\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = RegExp(pattern);
    if (value.isEmpty) return 'Message is required';
    // if (!regex.hasMatch(value))
    //   return 'Enter a valid Message';
    else
      return null;
  }

// ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR VALIDATING MESSAGE ######
   *******************************************************************/
  validateAndSubmit () async {
    if(validateAndSave()){

      // ===> SETTING CIRCULAR PROGRESS BAR TO TRUE <===
      setState(() {
        loading = true;
      });
      try{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavScreen()));

        // ===> This helps to get the uid in the dB <===
        User user = auth.currentUser;

        // ===> Am using the uid to make data retrieving easier <===
        await FirebaseFirestore.instance.collection("contact_us").doc(user.uid).set({
          'uid': user.uid,
          'Full Name': fname,
          'Phone Number': mobile,
          'Email Address': email,
          'Message': message,
        }).then((_){
          print("success!");
        });
        setState(() {
          loading = false;
        });
      }
      catch(e){
        print(e);
        }
    }
    else {
      setState(() {
        autovalidate = true;
      });
    }
  }

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Color(0xffffffff),
    size: 50.0,
  );


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
            "Contact Us".toUpperCase(),
            style: TextStyle(
                color: Palette.pinkAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2),
          ),
          centerTitle: true,
          leading: Stack(children: [
            CircleButtons(
              iconData: Icons.menu,
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

                          // if(snapshot != null && snapshot.data != null) return spinkit;

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
          child: ModalProgressHUD(
            inAsyncCall: loading,
            opacity: 0.5,
            progressIndicator: spinkit,
            color: Palette.pinkAccent,
            child: ListView(children: [
              loading ? spinkit : Text(" "),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                      key: _form,
                      autovalidate: autovalidate,
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            color: Palette.pinkAccent,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "Please fill this form in a decent manner".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                          // ===> FOR FULL NAME <===
                          Padding(
                            padding: EdgeInsets.only(top: 3, bottom: 5),
                            child: Container(
                              color: Colors.white,
                              child: TextFormField(
                                controller: fnameController,
                                maxLines: 1,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  fname = fname;
                                },
                                validator: validateFName,
                                onSaved: (value) => fname = value,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1, color: Palette.pinkAccent),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.pinkAccent)),
                                  labelText: 'Full Name',
                                  // prefixIcon: Icon(Icons.person_outline,
                                  //   color: Colors.black,),
                                  labelStyle: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10,),

                          // ===> FOR PHONE NUMBER <===
                          Padding(
                            padding: EdgeInsets.only(top: 3, bottom: 5),
                            child: Container(
                              color: Colors.white,
                              child: TextFormField(
                                controller: mobileController,
                                maxLines: 1,
                                autofocus: false,
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  mobile = mobile;
                                },
                                validator: validateMobile,
                                onSaved: (value) => mobile = value,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1, color: Palette.pinkAccent),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.pinkAccent)),
                                  labelText: 'Phone Number',
                                  // prefixIcon: Icon(Icons.person_outline,
                                  //   color: Colors.black,),
                                  labelStyle: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10,),

                          // ===> FOR EMAIL ADDRESS <===
                          Padding(
                            padding: EdgeInsets.only(top: 3, bottom: 5),
                            child: Container(
                              color: Colors.white,
                              child: TextFormField(
                                controller: emailController,
                                autofocus: false,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  email = value;
                                },
                                validator: validateEmail,
                                onSaved: (value) => email = value,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  // counterText: ' ', // ===> THIS REMOVES THE BUTTON COUNTER <===
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Palette.pinkAccent),
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Email Address',
                                    // prefixIcon: Icon(Icons.person_outline,
                                    //   color: Colors.black,),
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.black54)),
                              ),
                            ),
                          ),

                          SizedBox(height: 10,),

                          // ===> FOR MESSAGE <===
                          Padding(
                            padding: EdgeInsets.only(top: 3, bottom: 5),
                            child: Container(
                              color: Colors.white,
                              child: TextFormField(
                                inputFormatters: [
                                  // this limit the number of characters
                                  LengthLimitingTextInputFormatter(300),// for mobile
                                ],
                                maxLength: 300, // this limit the number of characters also
                                controller: messageController,
                                maxLines: 5,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  message = value;
                                },
                                validator: validateMessage,
                                onSaved: (value) => message = value,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1, color: Palette.pinkAccent),
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Message',
                                    // prefixIcon: Icon(Icons.person_outline,
                                    //   color: Colors.black,),
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.black54)),
                              ),
                            ),
                          ),

                          // ===> FOR SUBMIT BUTTON <===
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: MaterialButton(
                              onPressed: loading ? null : validateAndSubmit,
                              child: Text(
                                'Submit'.toUpperCase(),
                                style: TextStyle(
                                  color: Palette.whiteColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // color: Color(0xffff2d55),
                              color: Palette.pinkAccent,
                              elevation: 0,
                              minWidth: 400,
                              height: 50,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ]),
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
