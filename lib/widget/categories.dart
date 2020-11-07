import 'package:flutter/material.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'category_list_items.dart';

class CategoriesIcons extends StatefulWidget {
  @override
  _CategoriesIconsState createState() => _CategoriesIconsState();
}

class _CategoriesIconsState extends State<CategoriesIcons> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
          shrinkWrap: true,
        scrollDirection: Axis.horizontal,
          children: <Widget>[
            CategoryItem(
              icon: IconData(0xe900, fontFamily: 'laptop'),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              onTap: (){
                print("t");
              },
              padding: EdgeInsets.all(10),
              backgroundColor: Color(0xFFffe291),
            ),
            CategoryItem(
              onTap: (){
                print("t");
              },
              icon: IconData(0xe900, fontFamily: 'iphone'),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(10),
              backgroundColor: Color(0xFF91bfff),
            ),
            CategoryItem(
              onTap: (){
                print("t");
              },
              icon: IconData(0xe900, fontFamily: 'android'),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(10),
              backgroundColor: Color(0xFFff91c1),
            ),
            CategoryItem(
              onTap: (){
                print("t");
              },
              icon: IconData(0xe900, fontFamily: 'camera',),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(10),
              // backgroundColor: Color(0xFF5340de),
              backgroundColor: Palette.pinkAccent,
            ),
            CategoryItem(
              icon: IconData(0xe900, fontFamily: 'laptop'),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(10),
              backgroundColor: Color(0xFFffe291),
            ),
            CategoryItem(
              icon: IconData(0xe956, fontFamily: 'desk'),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(10),
              backgroundColor: Color(0xFFA52A2A),
            ),
            CategoryItem(
              icon: IconData(0xe900, fontFamily: 'android'),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(10),
              backgroundColor: Color(0xFFff91c1),
            ),
            CategoryItem(
              icon: IconData(0xe900, fontFamily: 'laptop_mac'),
              size: 50,
              margin: EdgeInsets.only(
                left: 10,
              ),
              padding: EdgeInsets.all(10),
              backgroundColor: Color(0xFF5340de),
            ),

            // CategoryItem(
            //   icon: EvaIcons.umbrellaOutline,
            //   size: 70,
            //   margin: EdgeInsets.only(
            //     left: 10,
            //   ),
            //   padding: EdgeInsets.all(10),
            //   backgroundColor: Color(0xFFff788e),
            // ),
            // CategoryItem(
            //   icon: EvaIcons.tvOutline,
            //   size: 70,
            //   margin: EdgeInsets.only(
            //     left: 10,
            //   ),
            //   padding: EdgeInsets.all(10),
            //   backgroundColor: Color(0xFFff9378),
            // ),

          ]
      ),
    );
  }
}
