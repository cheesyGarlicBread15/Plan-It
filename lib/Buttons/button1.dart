import 'package:flutter/material.dart';

class Button1 extends StatefulWidget {
  Function func;
  String text;
  Button1({super.key, required this.func, required this.text});

  @override
  State<Button1> createState() => _Button1State();
}

class _Button1State extends State<Button1> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.func(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Background color
        foregroundColor: Colors.white, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding
        elevation: 2, // Slight shadow
      ),
      child: Text(widget.text),
    );
  }
}