import 'package:flutter/material.dart';
class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double diam = 55;
    return Container(
      width: diam,
      height: diam,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        shape: BoxShape.circle,
      ),);
  }}

