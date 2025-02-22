import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  final String CategoryTitle;

  const ReusableText({super.key, required this.CategoryTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          CategoryTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}
