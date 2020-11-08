import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/transitionroute.dart';
import 'package:upgradeecomm/credentials/register.dart';
import 'package:upgradeecomm/services/auth.dart';
import 'package:upgradeecomm/credentials/forgotpwd.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  // ===> Declaring Variables <===
  String email;
  String password;
  String uid;
  User user;
  bool loading = false;
  bool _autoValidate = false;
  String errorMsg = " ";
  bool _obscurePwd = true;

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  //=====> FUNCTION FOR _toggleLogin <=====
  void _toggleLogin() {
    setState(() {
      _obscurePwd = !_obscurePwd;
    });
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING BOTH LOGIN & REGISTER EMAIL #######
   ****************************************************************/
  String validateEmail(String value) {
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
  /***********************************************************************
      ######## FOR VALIDATING LOGIN & REGISTER EMAIL PASSWORD #######
   ************************************************************************/

  String validatePassword(String value) {
    if (value.isEmpty) return 'Password is required';

    if (value.length < 8)
      return 'Must be at least 8 characters long';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### CHECKING IF LOGIN FORM IS VALID BEFORE SUBMITTING ######
   *******************************************************************/
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // ignore: slash_for_doc_comments
  /**********************************************************
      ###### FOR VALIDATING LOGIN BTN #######
   *********************************************************/

  validateLoginBtnAndSubmit() async {
    if (validateAndSave()) {
      // ===> SETTING CIRCULAR PROGRESS BAR TO TRUE <===
      setState(() {
        loading = true;
      });
      try {
        final user =
            await AuthHelper.signInWithEmail(email: email, password: password);
        if (user != null) {
          print("login successful");
        }
        setState(() {
          loading = false;
        });
      }catch (e) {
        _scaffoldkey.currentState.showSnackBar(SnackBar(
          backgroundColor: Palette.pinkAccent,
          content: Text(
            "Login not successful. Try Again",
            style: TextStyle(color: Palette.whiteColor),
          ),
        ));
      }
    }
  }

  // ===> Implementing _showAlertDialog function <===
  _showAlertDialog(errorMsg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Login Failed',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(errorMsg),
          );
        });
  }

  // ===> THIS FUNCTION IS SPINKIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: Palette.pinkAccent,
        body: ModalProgressHUD(
          inAsyncCall: loading,
          opacity: 0.5,
          progressIndicator: spinkit,
          color: Color(0xff706695),
          child: Stack(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(top: 80, left: 30),
                child: Text(
                  "Sign In".toUpperCase(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 240),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(23),
                        child: ListView(
                          padding: EdgeInsets.only(top: 1),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 20),
                              child: Container(
                                color: Colors.white,
                                child: TextFormField(
                                  maxLines: 1,
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
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Palette.pinkAccent),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: 'Email Address',
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        color: Colors.black,
                                      ),
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: TextFormField(
                                maxLines: 1,
                                autofocus: false,
                                obscureText: _obscurePwd,
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: validatePassword,
                                onSaved: (value) => password = value,
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
                                    labelText: 'Password',
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: _toggleLogin,
                                      child: Icon(
                                        _obscurePwd
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Color(0xff706695),
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    )),
                              ),
                            ),

                            // ===> FORGOT PASSWORD STARTS FROM HERE <===
                            Padding(
                              padding: EdgeInsets.only(top: 8, left: 150),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    // ===> Navigate to Forgotten pwd Screen <===
                                    Navigator.push(
                                        context,
                                        TransitionPageRoute(
                                            widget: ForgotPwdScreen()));
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ===> SIGN IN BUTTON STARTS FROM HERE <===
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: MaterialButton(
                                onPressed: validateLoginBtnAndSubmit,
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
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

                            // ===> SIGN UP TEXT STARTS FROM HERE <===
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Don't have an Account?",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        )),
                                    TextSpan(
                                        text: ' Sign Up',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // ===> Navigate to Login Screen <===
                                            Navigator.push(
                                                context,
                                                TransitionPageRoute(
                                                    widget: RegisterScreen()));
                                          }),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
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
