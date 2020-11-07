import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final IconData icon;
  final Function onTap;
  final Image image;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  CategoryItem(
      {@required this.backgroundColor,
      @required this.size,
      this.icon,
      @required this.margin,
      @required this.padding,
      this.iconColor = Colors.white,
      this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size),
      ),
      padding: padding,
      margin: margin,
      child: Icon(
        icon,
        color: iconColor,
      ),
    );
  }
}
