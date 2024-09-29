import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class ManualQuizScreen extends StatefulWidget {
  const ManualQuizScreen({super.key});

  @override
  _ManualQuizScreenState createState() => _ManualQuizScreenState();
}

class _ManualQuizScreenState extends State<ManualQuizScreen> {
  final TextEditingController _quizTitleController = TextEditingController();
  final List<Map<String, dynamic>> _questions = []; // List to hold quiz questions
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers = []; // For multiple answers
  int _correctAnswerIndex = 0; // Track the index of the correct answer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _quizTitleController,
              decoration: const InputDecoration(labelText: 'Quiz Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 15),
            // Adding answer inputs dynamically
            ..._buildAnswerInputs(),
            const SizedBox(height: 15),
            DropdownButton<int>(
              value: _correctAnswerIndex,
              onChanged: (value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
              items: List.generate(
                _answerControllers.length,
                    (index) => DropdownMenuItem(
                  value: index,
                  child: Text('Answer ${index + 1}'),
                ),
              ),
              hint: const Text('Select Correct Answer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text('Add Question'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveQuiz,
              child: const Text('Save Quiz'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_questions[index]['question']),
                    subtitle: Text('Answers: ${_questions[index]['answers'].join(', ')}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswerInputs() {
    return List<Widget>.generate(
      _answerControllers.length,
          (index) {
        return TextField(
          controller: _answerControllers[index],
          decoration: InputDecoration(labelText: 'Answer ${index + 1}'),
        );
      },
    )..add(
      ElevatedButton(
        onPressed: _addAnswerField, // Button to add more answer fields
        child: const Text('Add Answer'),
      ),
    );
  }

  void _addAnswerField() {
    setState(() {
      _answerControllers.add(TextEditingController());
    });
  }

  void _addQuestion() {
    if (_questionController.text.isNotEmpty && _answerControllers.isNotEmpty) {
      final answers = _answerControllers.map((controller) => controller.text).toList();
      setState(() {
        _questions.add({
          'question': _questionController.text,
          'answers': answers,
          'correctAnswerIndex': _correctAnswerIndex, // Save the correct answer index
        });
        _questionController.clear();
        _answerControllers.clear(); // Clear answers after adding the question
        _correctAnswerIndex = 0; // Reset the correct answer index
      });
    }
  }

  Future<void> _saveQuiz() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid; // Get user ID
      await FirebaseFirestore.instance.collection('quizzes').add({
        'userId': uid,
        'quizTitle': _quizTitleController.text,
        'questions': _questions,
        'createdAt': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz saved successfully!')),
      );
      Navigator.pop(context); // Go back to home screen after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
