// special_description_text.dart
import 'package:flutter/material.dart';

class SpecialDescription extends StatelessWidget {
  final String text;

  const SpecialDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
