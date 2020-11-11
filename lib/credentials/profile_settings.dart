import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/constant/botnav.dart';

class ProfileSettingScreen extends StatefulWidget {
  @override
  _ProfileSettingScreenState createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  String name;
  String location;
  String mobile;
  bool loading = false;
  String ImageUrl;
  String imageId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _autoValidate = false;
  String errorMsg = " ";

  File _imageFile;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  clearForm() {
    setState(() {
      _imageFile = null;
      nameController.clear();
      mobileController.clear();
      locationController.clear();
    });
  }


  // ===> Select an image via gallery or camera <===
  getImageFile(ImageSource source) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(
      source: source,
    );

    setState(() {
      _imageFile = image;
    });
  }

  //=====> FOR INSTANCES OF FIREBASE <=====
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection("users");
  final dBase = FirebaseFirestore.instance.collection("address");
  User user = FirebaseAuth.instance.currentUser;

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### CREATING A FUNCTION TO PICK IMAGES FROM GALLERY ######
   *******************************************************************/
  Future pickImage() async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = _image;
    });
  }

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Colors.white,
    size: 50.0,
  );


  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING USER NAME #######
   ****************************************************************/
  String validateName(String value){
    // Pattern pattern =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}'
    //     r'\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = RegExp(pattern);
    if (value.isEmpty) return 'Name is required';
    // if (!regex.hasMatch(value))
    //   return 'Enter a valid Name';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /***************************************************************
      ######## FOR VALIDATING LOCATOIN #######
   ****************************************************************/
  String validateLocation(String value){
    if (value.isEmpty) return 'Location is required';
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
      return 'Phone Number is required';
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
  /**********************************************************
      ###### FOR VALIDATING AND SUBMITTING #######
   *********************************************************/
  validateAndSubmit(){

    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    'Please select an image',
                    style: TextStyle(color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              content: Text(errorMsg),
            );
          }
      );
    }

    else if(validateAndSave()){
      // ===> SETTING CIRCULAR PROGRESS BAR TO TRUE <===
      setState(() {
        loading = true;
      });

      print("t");

      try {
        uploadImage();
      } catch (e){
        // ===> Handle error i.e display notification or toast <===
        print(e.toString());
      }
    }
  }

  uploadImage () async{
    String userImage = DateTime.now().millisecondsSinceEpoch.toString();

    // ===> Create reference to Firebase Storage <===
    StorageReference storageReference = FirebaseStorage.instance.ref().child("users");
    StorageUploadTask storageUploadTask = storageReference.child("image_$imageId.jpg").putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((urlImage) async {
      ImageUrl = urlImage;

      // ===> CREATING A FUNCTION FOR SAVING USER INFO <===
      saveUserInfo();
      saveUserInfoForAdmin();
    });
  }

  // ===> SAVING USER INFO FOR USER <===
  Future saveUserInfo(){
    // ===> SETTING CIRCULAR PROGRESS BAR TO FALSE <===
    setState(() {
      loading = false;
    });

    // ===> INFO SAVE SUCCESSFULLY. SEND USER TO THE ACCOUNT SCREEN
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomNavScreen()),
    );

    return db.doc(user.uid).collection("Profile").doc(user.uid).set({
      "User Name": name,
      "Phone Number": mobile,
      "Location": location,
      "Profile Pic": ImageUrl,
    }).then((_) {
      print("Success");
    });;
  }


  // ===> SAVING USER ADDRESS/INFO FOR ADMIN <===
  Future saveUserInfoForAdmin(){
    // ===> SETTING CIRCULAR PROGRESS BAR TO FALSE <===
    setState(() {
      loading = false;
    });

    // ===> INFO SAVE SUCCESSFULLY. SEND USER TO THE ACCOUNT SCREEN
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => BottomNavScreen()),
    // );

    return dBase.doc(user.uid).set({
      "User Name": name,
      "Phone Number": mobile,
      "Location": location,
      "Profile Pic": ImageUrl,
    }).then((_) {
      print("Success");
    });;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Palette.pinkAccent,
          body: SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: loading,
              opacity: 0.5,
              progressIndicator: spinkit,
              color: Palette.pinkAccent,
              child: Form(
                key: _form,
                autovalidate: _autoValidate,
                child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30, left: 30),
                        child: Text("Set Up Profile".toUpperCase(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),),
                      ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        // height: 225,
                        //color: Colors.red,
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => pickImage(),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      radius: 70,
                                      child: ClipOval(
                                        child: SizedBox(
                                          height: 150,
                                          width: 150,
                                          child: _imageFile == null
                                              ? Center(
                                            child: Image.asset(
                                              "images/placeholder.png",
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                              : Image.file(
                                            _imageFile,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // ===> FOR FULL NAME <===
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 5,
                                  left: 20, right: 20),
                              child: Container(
                                color: Colors.white,
                                child: TextFormField(
                                  controller: nameController,
                                  maxLines: 1,
                                  autofocus: false,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    name = name;
                                  },
                                  validator: validateName,
                                  onSaved: (value) => name = value,
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
                                        BorderSide(color: Palette.pinkAccent)
                                    ),
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
                              padding: EdgeInsets.only(top: 3, bottom: 5,
                                  left: 20, right: 20),
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

                            // ===> FOR LOCATION ADDRESS <===
                            Padding(
                              padding: EdgeInsets.only(top: 3, bottom: 5,
                                  left: 20, right: 20),
                              child: Container(
                                color: Colors.white,
                                child: TextFormField(
                                  controller: locationController,
                                  maxLines: 1,
                                  autofocus: false,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    location = value;
                                  },
                                  validator: validateLocation,
                                  onSaved: (value) => location = value,
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
                                      labelText: 'Location',
                                      // prefixIcon: Icon(Icons.person_outline,
                                      //   color: Colors.black,),
                                      labelStyle: TextStyle(
                                          fontSize: 15, color: Colors.black54)),
                                ),
                              ),
                            ),

                            // ===> FOR MATERIAL BUTTON <===
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10,
                                  left: 20, right: 20),
                              child: MaterialButton(
                                onPressed: validateAndSubmit,
                                child: Text('SAVE PROFILE',
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
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
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
    color: Palette.pinkAccent,
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


