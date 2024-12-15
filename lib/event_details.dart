import 'package:flutter/material.dart';

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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(widget.eventData['name']),
            const SizedBox(height: 10,),
            Text(widget.eventData['description']),
            const SizedBox(height: 10,),
            Text(widget.eventData['coordinates']),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () => _endEvent(),
              child: const Text('End'),
            )
          ],
        ),
      ),
    );
  }
}