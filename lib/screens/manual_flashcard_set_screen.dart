import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class ManualFlashcardSetScreen extends StatefulWidget {
  @override
  _ManualFlashcardSetScreenState createState() => _ManualFlashcardSetScreenState();
}

class _ManualFlashcardSetScreenState extends State<ManualFlashcardSetScreen> {
  final TextEditingController _setTitleController = TextEditingController();
  final List<Map<String, String>> _flashcards = []; // List to hold flashcards
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flashcard Set'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _setTitleController,
              decoration: InputDecoration(labelText: 'Flashcard Set Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _termController,
              decoration: InputDecoration(labelText: 'Term'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _definitionController,
              decoration: InputDecoration(labelText: 'Definition'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                _addFlashcard();
              },
              child: const Text( style: TextStyle(color:Colors.white), 'Add Flashcard'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber) ,
              onPressed: () {
                _saveFlashcardSet();
              },
              child: const Text( style: TextStyle(color:Colors.white),'Save Flashcard Set'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _flashcards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_flashcards[index]['term']!),
                    subtitle: Text(_flashcards[index]['definition']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addFlashcard() {
    if (_termController.text.isNotEmpty && _definitionController.text.isNotEmpty) {
      setState(() {
        _flashcards.add({
          'term': _termController.text,
          'definition': _definitionController.text,
        });
        _termController.clear();
        _definitionController.clear();
      });
    }
  }

  Future<void> _saveFlashcardSet() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid; // Get user ID
      await FirebaseFirestore.instance.collection('flashcards').add({
        'userId': uid,
        'setTitle': _setTitleController.text,
        'flashcards': _flashcards,
        'createdAt': Timestamp.now(),
      });
      Navigator.pop(context); // Go back to home screen after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
