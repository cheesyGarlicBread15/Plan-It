import 'package:flutter/material.dart';

class EventDetails extends StatefulWidget {
  final Map<dynamic, dynamic> eventData;
  const EventDetails({super.key, required this.eventData});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(widget.eventData['description']),
    );
  }
}