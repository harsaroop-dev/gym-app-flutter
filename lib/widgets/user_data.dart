import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  const UserData({
    super.key,
    required this.icon,
    required this.data,
    required this.color,
  });

  final IconData icon;
  final String data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 80,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.25),
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'The Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // const SizedBox(height: 5),
        Text(
          data,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }
}
