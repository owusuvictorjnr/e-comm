import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:upgradeecomm/config/colors.dart';

class CreateNecklaceUploadForm extends StatefulWidget {
  @override
  _CreateNecklaceUploadFormState createState() =>
      _CreateNecklaceUploadFormState();
}

class _CreateNecklaceUploadFormState extends State<CreateNecklaceUploadForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  String title;
  String category;
  String description;
  String price;
  String discount;
  String thumbnailUrl;
  Timestamp publishedDate;
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool autovalidate = false;
  bool loading = false;

  // ===> Text Input Controllers <===
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  clearForm() {
    setState(() {
      _imageFile = null;
      titleController.clear();
      categoryController.clear();
      descController.clear();
      priceController.clear();
    });
  }

  //===> Active image file <===
  File _imageFile;

  // ===> Select an image via gallery or camera <===
  getImageFil(ImageSource source) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(
      source: source,
    );

    setState(() {
      _imageFile = image;
      print(_imageFile.lengthSync());
    });
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR VALIDATING TITLE ######
   *******************************************************************/
  String validateTitle(String value) {
    if (value.isEmpty) return ("Product Title is required");
    if (value.length < 3) return 'Must be more 3 characters';
    if (value.length > 15)
      return 'Must be below 15 characters';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR VALIDATING DESCRIPTION ######
   *******************************************************************/
  String validateDescription(String value) {
    if (value.isEmpty) return ("Product Description is required");
    if (value.length < 3)
      return 'Must be more 3 characters';
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR VALIDATING CATEGORY ######
   *******************************************************************/
  String validateCategory(String value) {
    if (value.isEmpty)
      return ("Product Category is required");
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR VALIDATING PRICE ######
   *******************************************************************/
  String validatePrice(String value) {
    if (value.isEmpty)
      return ("Product Price is required");
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR VALIDATING DISCOUNT ######
   *******************************************************************/
  String validateDiscount(String value) {
    if (value.isEmpty)
      return ("Product Discount is required");
    else
      return null;
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### VALIDATING AND SAVING FORM ######
   *******************************************************************/
  bool validateAndSave() {
    final form = _form.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR VALIDATING AND SUBMITTING ######
   *******************************************************************/
  Future<String> validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        loading = true;
      });
      String imageDownloadUrl = await uploadingImage(_imageFile);

      saveProductInfo(imageDownloadUrl);

      // Login successful. Navigate to Home Screen
      // Navigator.push(context, TransitionPageRoute(widget: BottomNavScreen()));
    }
  }

  // ===> FOR STORING IMAGES IN FIREBASE STORAGE <===
  Future<String> uploadingImage(File imageFile) async {
    final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("necklaces");
    StorageUploadTask uploadTask =
    storageReference.child("product_$productId.jpg").putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // ===> FOR SAVING PRODUCT INFO <===
  saveProductInfo(String downloadUrl) {
    final productRef = FirebaseFirestore.instance.collection("necklaces");
    productRef.doc(productId).set({
      "Product Title": titleController.text.trim(),
      "Product Category": categoryController.text.trim(),
      "Product Description": descController.text.trim(),
      "Product Price": priceController.text.trim(),
      "Status": 'available',
      "Published Date": DateTime.now(),
      "thumbnail": downloadUrl,
    });

    setState(() {
      _imageFile = null;
      loading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      titleController.clear();
      categoryController.clear();
      descController.clear();
      priceController.clear();
    });
  }

  // ===> THIS FUNCTION IS SPIN KIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Color(0xffffffff),
    size: 50.0,
  );

  // ignore: slash_for_doc_comments
  /*******************************************************************
      ##### FOR PICKING IMAGES ######
   *******************************************************************/
  pickImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Center(
              child: Text(
                "CHOOSE IMAGE: ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            children: [
              // ===> SELECT FROM GALLERY <===
              SimpleDialogOption(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, bottom: 6),
                    child: Text(
                      "From Gallery",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                onPressed: () => getImageFil(ImageSource.gallery),
              ),

              // ===> SELECT FROM CAMERA <===
              SimpleDialogOption(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, bottom: 6),
                    child: Text(
                      "From Camera",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                onPressed: () => getImageFil(
                  ImageSource.camera,
                ),
              ),

              // ===> CANCEL <===
              SimpleDialogOption(
                child: RaisedButton(
                    color: Palette.pinkAccent,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Palette.blackColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Palette.whiteColor,
        title: Text(
          "UPLOAD NECKLACES",
          style: TextStyle(
              color: Palette.blackColor,
              fontSize: 18,
              letterSpacing: -1.2),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: loading,
          opacity: 0.5,
          progressIndicator: spinkit,
          color: Palette.pinkAccent,
          child: ListView(children: [
            loading ? spinkit : Text(" "),
            Padding(
              padding: EdgeInsets.only(top: 2, bottom: 15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: Form(
                    key: _form,
                    autovalidate: autovalidate,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () => pickImage(context),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 15.0),
                              width: MediaQuery.of(context).size.width,
                              height: 176.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: _imageFile == null
                                  ? Center(
                                child: Image.asset(
                                  "images/img_plcholder.png",
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Image.file(_imageFile,
                                  height: 200, width: 200),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Add Details",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        // ===> FOR PRODUCT TITLE <===
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 5),
                          child: Container(
                            color: Colors.white,
                            child: TextFormField(
                              controller: titleController,
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                title = title;
                              },
                              validator: validateTitle,
                              onSaved: (value) => title = value,
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
                                labelText: 'Product Title',
                                // prefixIcon: Icon(Icons.person_outline,
                                //   color: Colors.black,),
                                labelStyle: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                            ),
                          ),
                        ),

                        // ===> PRODUCT DESCRIPTION <===
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 5),
                          child: Container(
                            color: Colors.white,
                            child: TextFormField(
                              controller: descController,
                              maxLines: 5,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                description = value;
                              },
                              validator: validateDescription,
                              onSaved: (value) => description = value,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              inputFormatters: [
                                // this limit the number of characters
                                LengthLimitingTextInputFormatter(300),// for mobile
                              ],
                              maxLength: 300, // this limit the number of characters also
                              decoration: InputDecoration(
                                // counterText: ' ', // ===> THIS REMOVES THE BUTTON COUNTER <===
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1, color: Palette.pinkAccent),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Product Description',
                                  // prefixIcon: Icon(Icons.person_outline,
                                  //   color: Colors.black,),
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        ),

                        // ===> FOR PRODUCT PRICE <===
                        Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 5),
                          child: Container(
                            color: Colors.white,
                            child: TextFormField(
                              controller: priceController,
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                price = value;
                              },
                              validator: validatePrice,
                              onSaved: (value) => price = value,
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
                                  labelText: 'Product Price',
                                  // prefixIcon: Icon(Icons.person_outline,
                                  //   color: Colors.black,),
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        ),

                        // ===> FOR UPLOAD BUTTON <===
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: MaterialButton(
                            onPressed: loading ? null : validateAndSubmit,
                            child: Text(
                              'Upload'.toUpperCase(),
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

class ItemModel {
  String title;
  String description;
  Timestamp publishedDate;
  String thumbnailUrl;
  String status;
  int price;

  ItemModel(
      {this.title,
        this.description,
        this.publishedDate,
        this.thumbnailUrl,
        this.status,
      });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    status = json['status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['status'] = this.status;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}