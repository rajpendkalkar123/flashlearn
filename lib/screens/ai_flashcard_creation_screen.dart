import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore to save flashcards and quizzes
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth for user management

class AiFlashcardCreationScreen extends StatefulWidget {
  const AiFlashcardCreationScreen({Key? key}) : super(key: key);

  @override
  _AiFlashcardCreationScreenState createState() => _AiFlashcardCreationScreenState();
}

class _AiFlashcardCreationScreenState extends State<AiFlashcardCreationScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _generateContent() async {
    final String apiKey = 'AIzaSyCdo7-KLx7OFoWxq8847FVMl3Ibq8W1TGo'; // Replace with your actual API key
    final String promptText = _inputController.text;

    setState(() {
      _isLoading = true;
      _result = ''; // Clear previous result
    });

    // Make a request to the Gemini API
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': promptText}, // Your input text
            ]
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if candidates exist in the response
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final content = data['candidates'][0]['content']; // Access the content
        if (content != null && content['parts'] != null && content['parts'].isNotEmpty) {
          final String generatedText = content['parts'][0]['text'];

          // Process the generated text to create flashcards and quizzes
          final flashcards = _extractFlashcards(generatedText);
          final quizzes = _extractQuizzes(generatedText);

          // Save the generated flashcards and quizzes to Firestore
          if (flashcards.isNotEmpty || quizzes.isNotEmpty) {
            final String uid = FirebaseAuth.instance.currentUser!.uid;

            // Create a Firestore document for the flashcard set
            DocumentReference setRef = await FirebaseFirestore.instance.collection('flashcardSets').add({
              'userId': uid,
              'setTitle': 'AI Generated Set', // Customize the title
              'createdAt': Timestamp.now(),
            });

            // Save each generated flashcard
            for (var flashcard in flashcards) {
              await setRef.collection('flashcards').add({
                'term': flashcard['term'], // Flashcard term
                'definition': flashcard['definition'], // Flashcard definition
              });
            }

            // Save each generated quiz
            for (var quiz in quizzes) {
              await FirebaseFirestore.instance.collection('quizzes').add({
                'quizTitle': quiz['title'], // Quiz title
                'description': quiz['description'], // Quiz description
                'userId': uid,
              });
            }

            setState(() {
              _result = 'Flashcards and quizzes generated successfully!'; // Success message
            });
          }
        } else {
          setState(() {
            _result = 'No valid content generated. Please check your input.';
          });
        }
      } else {
        setState(() {
          _result = 'No candidates returned. Please try again.';
        });
      }
    } else {
      setState(() {
        _result = 'Error: ${response.body}'; // Display error message
      });
    }

    setState(() {
      _isLoading = false; // Stop the loading indicator
    });
  }

  List<Map<String, String>> _extractFlashcards(String generatedText) {
    // Implement your logic to extract flashcards from the generated text
    // For example, split the text by lines, and create a list of flashcards

    List<Map<String, String>> flashcards = [];
    // Sample parsing logic: Assuming each line represents a flashcard
    var lines = generatedText.split('\n');
    for (var line in lines) {
      if (line.isNotEmpty) {
        var parts = line.split(':'); // Assuming format is "Term: Definition"
        if (parts.length == 2) {
          flashcards.add({
            'term': parts[0].trim(),
            'definition': parts[1].trim(),
          });
        }
      }
    }
    return flashcards;
  }

  List<Map<String, String>> _extractQuizzes(String generatedText) {
    // Implement your logic to extract quizzes from the generated text
    // For example, identify questions and choices in the text

    List<Map<String, String>> quizzes = [];
    // Sample parsing logic: You can define your own structure
    // Example: Split questions from the generated text
    var questions = generatedText.split('\n');
    for (var question in questions) {
      if (question.isNotEmpty) {
        quizzes.add({
          'title': question, // You can modify this structure based on your needs
          'description': 'Quiz for: $question', // Placeholder description
        });
      }
    }
    return quizzes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Flashcards with AI'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Enter text paragraph',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateContent,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator
                  : const Text('Generate Flashcards & Quizzes'),
            ),
            const SizedBox(height: 16),
            Text(_result), // Display the result here
          ],
        ),
      ),
    );
  }
}
