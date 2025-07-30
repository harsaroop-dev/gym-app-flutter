import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  const Circle({
    super.key,
    required this.diameter,
    required this.color,
    this.border,
  });

  final double diameter;
  final Color color;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1000),
        border: border,
      ),
    );
  }
}
