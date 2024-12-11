import 'package:flutter/material.dart';

class CreateEvent extends StatelessWidget {
  CreateEvent({super.key});

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  void _create() {
    print(nameController.text);
    print(descriptionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
      child: Container(
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
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Exit'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _create,
                    child: const Text('Create'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}