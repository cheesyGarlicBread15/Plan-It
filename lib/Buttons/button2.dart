import 'package:flutter/material.dart';

class Button2 extends StatefulWidget {
  final Function func;
  final String text;

  const Button2({super.key, required this.func, required this.text});

  @override
  State<Button2> createState() => _Button2State();
}

class _Button2State extends State<Button2> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.func(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Transparent background
        foregroundColor: Colors.blue, // Text color
        side: BorderSide(color: Colors.blue, width: 2), // Border color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding
        elevation: 0, // No shadow for any state
      ).copyWith(
        shadowColor: MaterialStateProperty.all(Colors.transparent), // No shadow
      ),
      child: Text(widget.text),
    );
  }
}
