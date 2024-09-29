import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryFlashcardsScreen extends StatelessWidget {
  final String category;

  const CategoryFlashcardsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('flashcards')
            .where('category', isEqualTo: category) // Query flashcards based on category
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No flashcards available for this category.'));
          }

          // Display the list of flashcards
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final flashcard = snapshot.data!.docs[index];
              final term = flashcard['term'] ?? 'No Term';  // Ensure this key exists in Firestore documents
              final definition = flashcard['definition'] ?? 'No Definition'; // Ensure this key exists too

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    term,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: term == 'No Term' ? Colors.red : Colors.black, // Highlight missing term
                    ),
                  ),
                  subtitle: Text(definition),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
