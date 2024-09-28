import 'package:flutter/material.dart';

class FlashcardListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Flashcards'),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        itemCount: 10, // Change this to your dynamic count later
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Flashcard $index'),
              subtitle: Text('Description of Flashcard $index'),
            ),
          );
        },
      ),
    );
  }
}
