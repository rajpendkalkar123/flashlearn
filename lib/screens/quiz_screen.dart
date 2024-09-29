import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;

  const QuizScreen({super.key, required this.quiz});

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
    var questions = (widget.quiz['questions'] as List<dynamic>?);

    if (questions == null || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Error'),
          backgroundColor: Colors.amber,
        ),
        body: const Center(
          child: Text(
            'No questions available for this quiz.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    var currentQuestion = questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz in Progress'),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProgressBar(questions.length),
            const SizedBox(height: 20),
            Text(
              currentQuestion['question'] ?? 'No question available',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (currentQuestion['answers'] != null)
              for (int i = 0; i < (currentQuestion['answers'] as List<dynamic>).length; i++)
                _buildOption(i, currentQuestion['answers'][i].toString())
            else
              const Text('No answers available for this question.'),
            const Spacer(),
            ElevatedButton(
              onPressed: _isReview ? _finishQuiz : _nextQuestion,
              child: Text(_isReview ? 'Finish Quiz' : 'Next Question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index, String optionText) {
    bool isSelected = index == _selectedOptionIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionIndex = index;
        });

        var questions = widget.quiz['questions'] as List<dynamic>;
        if (_selectedOptionIndex == questions[_currentQuestionIndex]['correctAnswerIndex']) {
          _score++;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey.shade300,
          ),
          color: isSelected ? Colors.amber.withOpacity(0.3) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              optionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.check_circle,
              color: isSelected ? Colors.amber : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int totalQuestions) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / totalQuestions,
          backgroundColor: Colors.amber.shade100,
          color: Colors.amber,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_currentQuestionIndex + 1} / $totalQuestions',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _nextQuestion() {
    if (_selectedOptionIndex != -1) {
      setState(() {
        if (_currentQuestionIndex < widget.quiz['questions'].length - 1) {
          _currentQuestionIndex++;
          _selectedOptionIndex = -1;
        } else {
          _isReview = true; // Enable review mode after the last question
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option.')),
      );
    }
  }

  void _finishQuiz() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quiz Completed! Your score: $_score/${widget.quiz['questions'].length}')),
    );

    // Optionally, navigate back or to another screen here
    Navigator.pop(context);
  }
}
