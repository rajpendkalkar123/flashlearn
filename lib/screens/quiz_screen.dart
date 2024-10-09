import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String quizTitle;
  final List<Map<String, dynamic>> questions;

  const QuizScreen({
    super.key,
    required this.quizTitle,
    required this.questions,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _selectedOptionIndex = -1;
  int _score = 0;
  bool _isReview = false;

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.quizTitle),
          backgroundColor: Colors.amber,
        ),
        body: const Center(
          child: Text('No questions available.'),
        ),
      );
    }

    if (_currentQuestionIndex >= widget.questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.quizTitle),
          backgroundColor: Colors.amber,
        ),
        body: const Center(
          child: Text('No more questions.'),
        ),
      );
    }

    final currentQuestion = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProgressBar(widget.questions.length),
            const SizedBox(height: 20),
            Text(
              currentQuestion['question'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion['answers'].length,
                itemBuilder: (context, index) {
                  return _buildOption(index, currentQuestion['answers'][index]);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isReview ? _finishQuiz : _nextQuestion,
              child: Text(_isReview ? 'Finish' : 'Next Question'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int totalQuestions) {
    return LinearProgressIndicator(
      value: (_currentQuestionIndex + 1) / totalQuestions,
      backgroundColor: Colors.grey[300],
      color: Colors.amber,
    );
  }

  Widget _buildOption(int index, String answer) {
    return RadioListTile<int>(
      title: Text(answer),
      value: index,
      groupValue: _selectedOptionIndex,
      onChanged: (value) {
        setState(() {
          _selectedOptionIndex = value!;
          if (index == widget.questions[_currentQuestionIndex]['correctAnswerIndex']) {
            _score++; // Increment score if the answer is correct
          }
        });
      },
    );
  }

  void _finishQuiz() {
    // Logic to handle quiz completion (e.g., saving score, showing results)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Finished!'),
        content: Text('Your score: $_score/${widget.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = -1; // Reset selected option
      });
    } else {
      setState(() {
        _isReview = true; // Switch to review mode
      });
    }
  }
}
