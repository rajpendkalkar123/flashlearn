import 'package:flutter/material.dart';

class ManualFlashcardScreen extends StatefulWidget {
  @override
  _ManualFlashcardScreenState createState() => _ManualFlashcardScreenState();
}

class _ManualFlashcardScreenState extends State<ManualFlashcardScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Flashcard Manually'), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Flashcard Title')),
            SizedBox(height: 15),
            TextField(controller: _contentController, decoration: InputDecoration(labelText: 'Flashcard Content'), maxLines: 6),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text('Create Flashcard')),
          ],
        ),
      ),
    );
  }
}
