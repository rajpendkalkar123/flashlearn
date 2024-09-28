import 'package:flutter/material.dart';

class CreateFlashcardScreen extends StatefulWidget {
  @override
  _CreateFlashcardScreenState createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Flashcard'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Flashcard Title'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Flashcard Description'),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to add flashcard
                Navigator.pop(context);
              },
              child: Text('Add Flashcard'),
            ),
          ],
        ),
      ),
    );
  }
}
