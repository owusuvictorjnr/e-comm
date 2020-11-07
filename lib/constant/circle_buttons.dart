import 'package:flutter/material.dart';

import '../config/colors.dart';
class CircleButtons extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double iconSize;
  final Function onPressed;

  const CircleButtons ({ Key key,
    this.iconData,
    this.iconSize,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Palette.whiteColor,
      ),
      child: IconButton(
        icon: Icon(iconData),
        iconSize: iconSize,
        color: Palette.blackColor,
        onPressed: onPressed,
      ),
    );
  }
}
