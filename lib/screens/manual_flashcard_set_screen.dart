import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManualFlashcardSetScreen extends StatefulWidget {
  const ManualFlashcardSetScreen({super.key});

  @override
  _ManualFlashcardSetScreenState createState() => _ManualFlashcardSetScreenState();
}

class _ManualFlashcardSetScreenState extends State<ManualFlashcardSetScreen> {
  final TextEditingController _setTitleController = TextEditingController();
  final List<Map<String, String>> _flashcards = [];
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
              decoration: const InputDecoration(labelText: 'Flashcard Set Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _termController,
              decoration: const InputDecoration(labelText: 'Term'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _definitionController,
              decoration: const InputDecoration(labelText: 'Definition'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: _addFlashcard,
              child: const Text('Add Flashcard', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: _saveFlashcardSet,
              child: const Text('Save Flashcard Set', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _flashcards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_flashcards[index]['term'] ?? 'No Term'),
                    subtitle: Text(_flashcards[index]['definition'] ?? 'No Definition'),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both term and definition.')),
      );
    }
  }

  Future<void> _saveFlashcardSet() async {
    try {
      // Check if the user is authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated. Please log in.')),
        );
        return;
      }

      // Create a document for the flashcard set
      DocumentReference setRef = await FirebaseFirestore.instance.collection('flashcardSets').add({
        'userId': user.uid,
        'setTitle': _setTitleController.text,
        'createdAt': Timestamp.now(),
      });

      // Save each flashcard as a sub-collection
      for (var flashcard in _flashcards) {
        await setRef.collection('flashcards').add({
          'term': flashcard['term'],
          'definition': flashcard['definition'],
        });
      }

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
