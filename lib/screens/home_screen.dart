import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Centered button in the bottom navigation bar
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            _showCreateFlashcardBottomSheet(context); // Show bottom sheet when button is pressed
          },
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          elevation: 12,
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white, width: 10.0, style: BorderStyle.solid),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // For the notch to house the floating button
        notchMargin: 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                icon: const SizedBox(child: Icon(Icons.home, color: Colors.amber)),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'profile');
                },
                icon: const Icon(Icons.person, color: Colors.amber),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Flashlearn',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Flashcards",
                  hintStyle: TextStyle(color: Colors.amber, fontSize: 18),
                  prefixIcon: Icon(Icons.search, color: Colors.amber),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Flashcard Categories', style: TextStyle(fontSize: 20, color: Colors.amber)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text("View All", style: TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: () {
                    // View all action
                  },
                ),
              ],
            ),
          ),
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

  // Show bottom sheet for flashcard creation options
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
              const Text('Create Flashcard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.create, color: Colors.amber),
                title: const Text('Create Flashcard Manually'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _showFlashcardTypeBottomSheet(context); // Show next bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.amber),
                title: const Text('Use AI to Create Flashcard'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  // Show AI flashcard creation if needed
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Show another bottom sheet for choosing between creating a flashcard set or quiz
  void _showFlashcardTypeBottomSheet(BuildContext context) {
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
              const Text('Choose Type', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.library_books, color: Colors.amber),
                title: const Text('Create Flashcard Set'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.pushNamed(context, 'manualFlashcardSet'); // Navigate to manual flashcard set screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.quiz, color: Colors.amber),
                title: const Text('Create Quiz'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.pushNamed(context, 'manualQuiz'); // Navigate to manual quiz screen
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, BuildContext context) {
    return InkWell(
      onTap: () {
        print(title);
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
