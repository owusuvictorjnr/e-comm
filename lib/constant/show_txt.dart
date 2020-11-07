import 'package:flutter/material.dart';
import 'package:upgradeecomm/config/colors.dart';

class ShowText extends StatefulWidget {
  @override
  _ShowTextState createState() => _ShowTextState();
}

class _ShowTextState extends State<ShowText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,


      children: [
        Text("Recently Bought Products",
        style: TextStyle(
          color: Palette.txtColor,
          // fontWeight: FontWeight.bold,
        ),
        ),
        GestureDetector(
          onTap: (){
            print("Open Categories");
          },
          child: Text(" ",
          style: TextStyle(
            color: Palette.txtColor,
            // fontWeight: FontWeight.bold
          ),),
        )
      ],
    );
  }
}

