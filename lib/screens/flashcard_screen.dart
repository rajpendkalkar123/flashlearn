import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardScreen extends StatefulWidget {
  final String flashcardSetId; // Pass the flashcard set ID

  const FlashcardScreen({super.key, required this.flashcardSetId});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late Future<List<Map<String, String>>> _flashcardsFuture;
  int _currentIndex = 0; // Track the currently displayed flashcard

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _fetchFlashcards(); // Fetch flashcards when the screen is initialized
  }

  Future<List<Map<String, String>>> _fetchFlashcards() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('flashcardSets')
        .doc(widget.flashcardSetId)
        .collection('flashcards')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>; // Use dynamic type
      return {
        'term': data['term']?.toString() ?? 'No Term', // Ensure type safety
        'definition': data['definition']?.toString() ?? 'No Definition',
      } as Map<String, String>; // Cast to Map<String, String>
    }).toList();
  }

  void _nextFlashcard(int totalFlashcards) {
    setState(() {
      _currentIndex = (_currentIndex + 1) % totalFlashcards; // Use total flashcards count
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _flashcardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final flashcards = snapshot.data ?? [];

          if (flashcards.isEmpty) {
            return const Center(child: Text('No flashcards available in this set.'));
          }

          // Display the current flashcard
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flashcard(
                term: flashcards[_currentIndex]['term']!,
                definition: flashcards[_currentIndex]['definition']!,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _nextFlashcard(flashcards.length), // Pass the number of flashcards
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Updated style
                ),
                child: const Text('Next Flashcard'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Flashcard extends StatefulWidget {
  final String term;
  final String definition;

  const Flashcard({super.key, required this.term, required this.definition});

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false; // Track if the card is flipped

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 180).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      if (_isFlipped) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: AnimatedBuilder(
            animation: _animation,
            child: Container(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(color: Colors.amber,),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Center(
                      child: _isFlipped
                          ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14), // Rotate the card 180 degrees
                        child: Text(
                          widget.definition,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      )
                          : Text(
                        widget.term,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(_animation.value * (3.14 / 180)),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
