import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateEvent extends StatelessWidget {
  final VoidCallback onCoordMark;
  CreateEvent({super.key, required this.onCoordMark});

  final dbRef = FirebaseDatabase.instance.ref("events");
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final coordController = TextEditingController();

  void _create(BuildContext context) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    dbRef.child(id).set(
      {
      'id' : id,
      'name' : nameController.text.toString(),
      'description' : descriptionController.text.toString(),
      'coordinates' : coordController.text.toString()
      });
    nameController.clear();
    descriptionController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    onCoordMark();
                  },
                  child: const Text('Mark'),
                ),
              ],
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
                    onPressed: () => _create(context),
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