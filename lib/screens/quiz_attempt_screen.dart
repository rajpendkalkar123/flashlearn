import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'quiz_screen.dart'; // Import the QuizScreen

class QuizAttemptScreen extends StatelessWidget {
  final String quizId; // Pass quizId to fetch specific quiz

  const QuizAttemptScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Attempt'),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('quizzes').doc(quizId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Quiz not found'));
          }

          final quizData = snapshot.data!.data() as Map<String, dynamic>;
          final quizTitle = quizData['quizTitle'];
          final List<dynamic> questions = quizData['questions'];

          // Transform the questions into a more usable format
          List<Map<String, dynamic>> quizQuestions = questions.map((question) {
            return {
              'question': question['question'],
              'answers': question['answers'],
              'correctAnswerIndex': question['correctAnswerIndex'],
            };
          }).toList();

          return QuizScreen(quizTitle: quizTitle, questions: quizQuestions);
        },
      ),
    );
  }
}
