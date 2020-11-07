import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upgradeecomm/config/colors.dart';

class FeaturedFoods extends StatefulWidget {
  @override
  _FeaturedFoodsState createState() => _FeaturedFoodsState();
}

class _FeaturedFoodsState extends State<FeaturedFoods> {
  // ===> Creating a List for the featured foods

  bool loading = false;
  
  
  List<String> images = [
    "images/UNADJUSTEDNONRAW_thumb_36a.jpg",
    "images/UNADJUSTEDNONRAW_thumb_364.jpg",
    "images/UNADJUSTEDNONRAW_thumb_368.jpg",
    "images/UNADJUSTEDNONRAW_thumb_370.jpg",
    "images/UNADJUSTEDNONRAW_thumb_369.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return  Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Card(
                    // color: Colors.blue,
                    child: Container(
                      child: Center(
                        child: Image.asset(images[index].toString(),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,),
                      ),
                    ),

                  ),
                ) ,
                Positioned(
                  left: 10,
                  bottom: 2,
                  right: 3,
                  child: Container(
                    height: 30,
                    width: 215,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black38,
                            Colors.black38,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 9,
                  child: Text("Name of Product",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Palette.whiteColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),),
                ),
              ]
            ),
          );
        },
      ),
    );
  }
}
