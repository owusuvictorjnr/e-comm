import 'package:flutter/material.dart';
import 'package:upgradeecomm/config/colors.dart';


class SearchService {}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => new _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.whiteColor,
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      child: TextFormField(
          style: TextStyle(color: Colors.black, fontSize: 15.0),
          cursorColor: Palette.pinkAccent,
          onChanged: (value){
            // startSearch();
          },
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
              suffixIcon: Material(
                  color: Palette.whiteColor,
                  elevation: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  child: Icon(
                    Icons.search,
                    color: Palette.txtLightColor,
                  ),
              ),
              border: InputBorder.none,
              hintText: "Search Product...",
              hintStyle: TextStyle(
                color: Palette.txtLightColor,
              ),
          ),
      ),
    );
  }
}

Widget buildResultCard(data) {
  return Card();
}
