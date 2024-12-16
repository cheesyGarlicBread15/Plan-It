import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_it/Buttons/button1.dart';
import 'package:plan_it/Texts/description.dart';
import 'package:plan_it/Texts/header.dart';
import 'package:plan_it/Texts/special_description.dart';

class EventDetails extends StatefulWidget {
  final Map<dynamic, dynamic> eventData;
  const EventDetails({super.key, required this.eventData});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  void _endEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to end this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print('Event deleted');
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('End'),
            ),
          ],
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat("MMMM dd, yyyy '@' h:mm a");
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(text: widget.eventData['name']),
            const SizedBox(height: 10,),
            if (widget.eventData['description']?.isNotEmpty ?? false)
              Column(
                children: [
                  Description(text: widget.eventData['description']),
                  const SizedBox(height: 10),
                ],
              ),
            SpecialDescription(text: 'Coordinates: ${widget.eventData['coordinates']}'),
            const SizedBox(height: 10,),
            SpecialDescription(text: 'Date and Time: ${formatDateTime(DateTime.parse(widget.eventData['schedule']))}',
            ),
            const SizedBox(height: 10,),
            // Button1(
            //   func: () => _endEvent(),
            //   text: 'End',
            // ),
          ],
        ),
      ),
    );
  }
}