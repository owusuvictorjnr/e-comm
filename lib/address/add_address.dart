import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:upgradeecomm/config/colors.dart';

import 'address_main.dart';


class NewAddressScreen extends StatefulWidget {
  final String addressId;

  const NewAddressScreen({Key key, this.addressId}) : super(key: key);

  @override
  _NewAddressScreenState createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String fname;
  String area;
  String mobile;
  String gps;
  String pcode;
  Timestamp publishedDate;
  bool autovalidate = false;
  bool loading = false;

  // ===> Text Input Controllers <===
  TextEditingController fnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pcodeController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController gpsController = TextEditingController();


  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection("users");
  User user = FirebaseAuth.instance.currentUser;

  //=====> FOR CLEAR FORM <=====
  clearForm() {
    setState(() {
      fnameController.clear();
      areaController.clear();
      mobileController.clear();
      emailController.clear();
      pcodeController.clear();
      gpsController.clear();
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
      ######## FOR VALIDATING PIN CODE #######
   ****************************************************************/
  String validatePCode(String value) {
    if (value.length == 0) {
      return 'Pin Code is required';
    }
    return null;
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING BOTH AREA NAME #######
   ****************************************************************/
  String validateArea(String value){
    if (value.isEmpty) return 'Area Name is required';
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
  String validateGPS (String value){
    // Pattern pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}'
    //     r'\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = RegExp(pattern);
    if (value.isEmpty) return 'GPS Address is required';
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
            MaterialPageRoute(builder: (context) => AddressMainScreen()));

        // ===> This helps to get the uid in the dB <===
        User user = auth.currentUser;

        // ===> Am using the uid to make data retrieving easier <===
    await db.doc(user.uid).collection("Address").doc(widget.addressId).set({
          'uid': user.uid,
          'Full Name': fname,
          'Phone Number': mobile,
          'Area Name': area,
          'Pin Code': pcode,
          'GPS Address': gps,
          "Published Date": DateTime.now(),
        }).then((_){

          final snackBar = SnackBar(content: Text("Address added successfully"));
          _scaffoldKey.currentState.showSnackBar(snackBar);
          FocusScope.of(context).requestFocus(FocusNode());
          _form.currentState.reset();
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Palette.whiteColor,
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
                                      width: 1,
                                      color: Palette.pinkAccent),
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

                        // ===> FOR AREA NAME <===
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 5),
                          child: Container(
                            color: Colors.white,
                            child: TextFormField(
                              controller: areaController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                area = value;
                              },
                              validator: validateArea,
                              onSaved: (value) => area = value,
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
                                  labelText: 'Area Name',
                                  // prefixIcon: Icon(Icons.person_outline,
                                  //   color: Colors.black,),
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        // ===> FOR GPS ADDRESS <===
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 5),
                          child: Container(
                            color: Colors.white,
                            child: TextFormField(
                              controller: gpsController,
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                gps = value;
                              },
                              validator: validateGPS,
                              onSaved: (value) => gps = value,
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
                                  labelText: 'GPS Address',
                                  // prefixIcon: Icon(Icons.person_outline,
                                  //   color: Colors.black,),
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        // ===> FOR PIN CODE <===
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 5),
                          child: Container(
                            color: Colors.white,
                            child: TextFormField(
                              controller: pcodeController,
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                pcode = value;
                              },
                              validator: validatePCode,
                              onSaved: (value) => pcode = value,
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
                                  labelText: 'PIN Code',
                                  // prefixIcon: Icon(Icons.person_outline,
                                  //   color: Colors.black,),
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        // ===> FOR SUBMIT BUTTON <===
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 10),
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
    );
  }
}