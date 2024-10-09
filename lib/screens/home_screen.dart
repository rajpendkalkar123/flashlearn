import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_flashcards_screen.dart'; // Screen for flashcard sets
import 'quiz_attempt_screen.dart'; // Screen for quiz attempts
import 'flashcard_screen.dart'; // Import the flashcard screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Handle search input changes
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    } else {
      _performSearch(query);
    }
  }

  // Perform search for flashcards and quizzes
  Future<void> _performSearch(String query) async {
    final flashcardsSnapshot = await FirebaseFirestore.instance.collection('flashcardSets').get();
    final quizzesSnapshot = await FirebaseFirestore.instance.collection('quizzes').get();

    List<Map<String, String>> results = [];

    for (var doc in flashcardsSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String title = data['setTitle']?.toString() ?? 'Untitled Flashcard';
      if (title.toLowerCase().contains(query)) {
        results.add({
          'type': 'flashcard',
          'id': doc.id,
          'title': title,
        });
      }
    }

    for (var doc in quizzesSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String title = data['quizTitle']?.toString() ?? 'Untitled Quiz';
      if (title.toLowerCase().contains(query)) {
        results.add({
          'type': 'quiz',
          'id': doc.id,
          'title': title,
        });
      }
    }

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            _showCreateFlashcardBottomSheet(context);
          },
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          elevation: 12,
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 10.0,
              style: BorderStyle.solid,
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != 'home') {
                    Navigator.pushReplacementNamed(context, 'home');
                  }
                },
                icon: const Icon(Icons.home_rounded, color: Colors.amber),
              ),
              IconButton(
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != 'profile') {
                    Navigator.pushNamed(context, 'profile');
                  }
                },
                icon: const Icon(Icons.person, color: Colors.amber),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title:
        Container(
          width: 200,
          height: 38,
          child: Image.asset('lib/assets/images/img2.png'),
          alignment: Alignment.topLeft
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'profile');
            },
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Flashcards or Quizzes",
                  hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                  prefixIcon: Icon(Icons.search, color: Colors.amber),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          if (_isSearching && _searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var result = _searchResults[index];
                  return ListTile(
                    title: Text(result['title'] ?? 'Untitled'),
                    subtitle: Text(result['type'] == 'flashcard' ? 'Flashcard Set' : 'Quiz'),
                    onTap: () {
                      if (result['type'] == 'flashcard') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlashcardScreen(
                              flashcardSetId: result['id']!, // Pass the flashcard set ID
                            ),
                          ),
                        );
                      } else if (result['type'] == 'quiz') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizAttemptScreen(quizId: result['id']!),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            )
          else if (_isSearching && _searchResults.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ),
          if (!_isSearching) // Original layout
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildCategoryCard(Icons.calculate, 'Mathematics', context),
                  _buildCategoryCard(Icons.science, 'Science', context),
                  _buildCategoryCard(Icons.business, 'Business', context),
                  _buildCategoryCard(Icons.computer, 'Computer', context),
                  _buildCategoryCard(Icons.book, 'Literature', context),
                  _buildCategoryCard(Icons.language, 'Language', context),
                  _buildCategoryCard(Icons.data_thresholding, 'Data Structure', context),
                  _buildCategoryCard(Icons.memory, 'DLCOA', context),
                  _buildCategoryCard(Icons.code, 'JAVA', context),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showCreateFlashcardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Create Flashcard or Quiz', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.create, color: Colors.amber),
                title: const Text('Create Manually'),
                onTap: () {
                  Navigator.pop(context); // Close the current bottom sheet
                  _showFlashcardOrQuizBottomSheet(context, true); // Show next bottom sheet for manual creation
                },
              ),
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.amber),
                title: const Text('Generate with AI'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.pushNamed(context, 'aiFlashcardCreation'); // Navigate to AI creation screen
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showFlashcardOrQuizBottomSheet(BuildContext context, bool isManual) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Choose Creation Type', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.note_add, color: Colors.amber),
                title: const Text('Create Flashcard'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.pushNamed(context, isManual ? 'manualFlashcardSet' : 'aiFlashcardCreation'); // Navigate to respective screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.quiz, color: Colors.amber),
                title: const Text('Create Quiz'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.pushNamed(context, isManual ? 'manualQuizSet' : 'aiQuizCreation'); // Navigate to respective screen
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryFlashcardsScreen(category: title), // Pass the selected category
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
