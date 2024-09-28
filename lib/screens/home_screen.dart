import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Centered button in the bottom navigation bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'createFlashcard');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.amber,
        elevation: 12,
        shape: CircleBorder(
          side: BorderSide(color: Colors.amber, width: 8.0, style: BorderStyle.solid),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // For the notch to house the floating button
        notchMargin: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                icon: Icon(Icons.home, color: Colors.amber),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'profile');
                },
                icon: Icon(Icons.person, color: Colors.amber),
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Flashlearn',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
            },
            icon: Icon(Icons.notifications, color: Colors.white),
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
                decoration: InputDecoration(
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
                Text('Flashcard Categories', style: TextStyle(fontSize: 20, color: Colors.amber)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: Text("View All", style: TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: () {
                    // View all action
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(16),
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
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
