import 'package:flutter/material.dart';
import 'package:sentinex/utils/my_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final double? width;
  final double? radius;
  final double? height;

  CustomButton({
    required this.onPressed,
    required this.text,
    this.color = Colors.white,
    this.textColor = const Color(0xFF001636),
    this.width = 300,
    this.radius = 10,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      minWidth: width,
      height: height,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
    );
  }
}
