import 'package:flutter/material.dart';

class FlashcardViewerScreen extends StatelessWidget {
  final List flashcards;

  const FlashcardViewerScreen({super.key, required this.flashcards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcard Viewer')),
      body: PageView.builder(
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          var flashcard = flashcards[index];
          return Card(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(flashcard['term'] ?? 'No Term', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  Text(flashcard['definition'] ?? 'No Definition', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
