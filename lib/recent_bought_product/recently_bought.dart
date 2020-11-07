import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentBoughtProduct extends StatefulWidget {
  @override
  _RecentBoughtProductState createState() => _RecentBoughtProductState();
}

class _RecentBoughtProductState extends State<RecentBoughtProduct> {
  List<String> images = [
    "images/UNADJUSTEDNONRAW_thumb_36a.jpg",
    "images/UNADJUSTEDNONRAW_thumb_364.jpg",
    "images/UNADJUSTEDNONRAW_thumb_368.jpg",
    "images/UNADJUSTEDNONRAW_thumb_370.jpg",
    "images/UNADJUSTEDNONRAW_thumb_369.jpg",
    "images/UNADJUSTEDNONRAW_thumb_370.jpg",
    "images/UNADJUSTEDNONRAW_thumb_366.jpg",
    "images/UNADJUSTEDNONRAW_thumb_362.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: ScrollPhysics(), //Added this to make it scrollable
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              Container(
                height: 150,
                width: 150,
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 5,
                child: Container(
                  height: 30,
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
                  child: Padding(
                    padding: EdgeInsets.only(left: 1, top: 6, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Product Name",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Price",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
