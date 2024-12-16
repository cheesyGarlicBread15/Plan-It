import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plan_it/Buttons/button1.dart';
import 'package:plan_it/Buttons/button2.dart';

class CreateEvent extends StatefulWidget {
  final Function onMarkEvent;
  final Map<String, dynamic> inputs;
  const CreateEvent({super.key, required this.onMarkEvent, required this.inputs});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final dbRef = FirebaseDatabase.instance.ref().child('events');
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final coordController = TextEditingController();
  DateTime dateTime = DateTime(2024, 12, 1, 0, 0);

  void _clearInputs() {
    nameController.clear();
    descriptionController.clear();
    coordController.clear();
    widget.inputs.clear();
  }

  bool checkIfInputsNotEmpty() {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event name required'))
      );
      return false;
    }
    if (coordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coordinates required'))
      );
      print('no coord');
      return false;
    }
    if (dateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date and Time required'))
      );
      return false;
    }

    return true;
  }

  void _create() {
    if (checkIfInputsNotEmpty()) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      dbRef.child(id).set({
        'id': id,
        'name': nameController.text.toString(),
        'description': descriptionController.text.toString(),
        'coordinates': coordController.text.toString(),
        'schedule' : dateTime.toIso8601String()
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
        _clearInputs();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $error')),
        );
      });
      widget.onMarkEvent(false);
      Navigator.pop(context);
    }
  }

  void _retainInputs() {
    nameController.text = widget.inputs.containsKey('eventName') ? widget.inputs['eventName'] : "";
    descriptionController.text = widget.inputs.containsKey('eventDescription') ? widget.inputs['eventDescription'] : "";
    coordController.text = widget.inputs.containsKey('eventCoordinates') ? widget.inputs['eventCoordinates'] : "";
    if (widget.inputs.containsKey('eventSchedule')) {
      dateTime = DateTime.parse(widget.inputs['eventSchedule']);
    }
  }

  @override
  void initState() {
    super.initState();
    _retainInputs();
  }

  void _saveInputs() {
    widget.inputs['eventName'] = nameController.text;
    widget.inputs['eventDescription'] = descriptionController.text;
    widget.inputs['eventCoordinates'] = coordController.text;
    widget.inputs['eventSchedule'] = dateTime.toIso8601String();
    Navigator.pop(context);
  }

  Future<DateTime?> pickDate() => showDatePicker(
    context: context, 
    initialDate: dateTime,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    );

  Future<TimeOfDay?> pickTime() => showTimePicker(
    context: context, 
    initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
    );

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2
                        ),
                      )
                    ),
                    
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2
                        ),
                      )
                    ),
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Coordinates',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2
                        ),
                      )
                    ),
                    controller: coordController,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Button1(
                        func: () {
                          widget.onMarkEvent(true);
                          _saveInputs();
                        },
                        text: 'Mark',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Button2(
                          func: () async {
                            final date = await pickDate();
                            if (date == null) return;
                        
                            final newDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              dateTime.hour,
                              dateTime.minute,
                            );
                        
                            setState(() {
                              dateTime = newDateTime;
                            });
                          },
                          text: '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                        ),
                      ),
                      const SizedBox(width: 12,),
                      Expanded(
                        child: Button2(
                          func: () async {
                            final time = await pickTime();
                            if (time == null) return;
          
                            final newDateTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              time.hour,
                              time.minute,
                            );
                            setState(() {
                              dateTime = newDateTime;
                            });
                          },
                          text: '$hours:$minutes',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Button1(
                          func: () {
                            widget.onMarkEvent(false);
                            _saveInputs();
                          },
                          text: 'Exit',
                        ),
                        const SizedBox(width: 20),
                        Button1(
                          func: () => _create(),
                          text: 'Create',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}