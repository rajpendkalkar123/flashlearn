import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'flashcard_screen.dart'; // Import your flashcard viewing screen
import 'manual_flashcard_set_screen.dart'; // Import your flashcard creation screen
import 'quiz_attempt_screen.dart'; // Import your quiz attempt screen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _usernameController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data on initialization
  }

  // Load the user data from Firestore
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userData = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _usernameController.text = userData['username'] ?? 'No Username'; // Ensure a default value
        _profileImage = userData['profileImageUrl'] != null
            ? File(userData['profileImageUrl'])
            : null; // Load the profile image URL
      });
    }
  }

  // Upload profile image to Firebase Storage
  Future<void> _uploadProfileImage() async {
    if (_profileImage != null) {
      User? user = _auth.currentUser;
      if (user != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        await ref.putFile(_profileImage!);
        String url = await ref.getDownloadURL();

        // Update Firestore with the new profile image URL
        await _firestore.collection('users').doc(user.uid).update({
          'profileImageUrl': url,
        });
      }
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
    await _uploadProfileImage(); // Automatically upload image once picked
  }

  // Update Username in Firestore
  Future<void> _updateUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'username': _usernameController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username updated successfully!')),
      );
    }
  }

  // Fetch the user's flashcard sets from Firestore
  Stream<QuerySnapshot> _getFlashcardSets() {
    User? user = _auth.currentUser;
    return _firestore
        .collection('flashcardSets')
        .where('userId', isEqualTo: user?.uid)
        .snapshots();
  }

  // Fetch the user's quizzes from Firestore
  Stream<QuerySnapshot> _getQuizzes() {
    User? user = _auth.currentUser;
    return _firestore
        .collection('quizzes')
        .where('userId', isEqualTo: user?.uid)
        .snapshots();
  }

  // Delete flashcard set by its document ID
  Future<void> _deleteFlashcardSet(String flashcardSetId) async {
    await _firestore.collection('flashcardSets').doc(flashcardSetId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Flashcard set deleted.')),
    );
  }

  // Delete quiz by its document ID
  Future<void> _deleteQuiz(String quizId) async {
    await _firestore.collection('quizzes').doc(quizId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quiz deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, 'Home'), // This is correct
        ),
        title: Text('User Profile', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to ManualFlashcardSetScreen when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManualFlashcardSetScreen(), // Navigate to flashcard creation screen
              ),
            );
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
                  Navigator.pop(context, 'home'); // Use pushReplacementNamed
                },
                icon: const Icon(Icons.home, color: Colors.amber),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context, 'profile'); // Use pushReplacementNamed
                },
                icon: const Icon(Icons.person, color: Colors.amber),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/placeholder.png'), // Placeholder image
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.camera_alt, color: Colors.amber, size: 30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.edit, color: Colors.amber),
                  onPressed: _updateUsername, // Update username in Firestore
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'My Flashcard Sets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getFlashcardSets(), // Stream flashcard sets
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final flashcardSets = snapshot.data!.docs;
                  if (flashcardSets.isEmpty) {
                    return Center(child: Text('No flashcard sets added.'));
                  }

                  return ListView.builder(
                    itemCount: flashcardSets.length,
                    itemBuilder: (context, index) {
                      var flashcardSet = flashcardSets[index].data() as Map<String, dynamic>;
                      String flashcardSetId = flashcardSets[index].id;

                      return ListTile(
                        title: Text(flashcardSet['setTitle']?.toString() ?? 'No Title'), // Ensure the field name matches your Firestore structure
                        subtitle: FutureBuilder<QuerySnapshot>(
                          future: _firestore
                              .collection('flashcardSets')
                              .doc(flashcardSetId)
                              .collection('flashcards')
                              .get(), // Get the flashcards in this set
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text('Loading flashcards...');
                            }
                            if (snapshot.hasError) {
                              return Text('Error loading flashcards');
                            }
                            final flashcards = snapshot.data!.docs;
                            return Text('Flashcards: ${flashcards.length}');
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _deleteFlashcardSet(flashcardSetId);
                          },
                        ),
                        onTap: () {
                          // Navigate to the FlashcardScreen when a flashcard set is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardScreen(
                                flashcardSetId: flashcardSetId, // Pass the flashcard set ID
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'My Quizzes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getQuizzes(), // Stream quizzes
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final quizzes = snapshot.data!.docs;
                  if (quizzes.isEmpty) {
                    return Center(child: Text('No quizzes added.'));
                  }

                  return ListView.builder(
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      var quiz = quizzes[index].data() as Map<String, dynamic>;
                      String quizId = quizzes[index].id; // Document ID for deletion

                      return ListTile(
                        title: Text(quiz['quizTitle']?.toString() ?? 'No Title'), // Ensure the field name matches your Firestore structure
                        subtitle: Text(quiz['description']?.toString() ?? 'No Description'), // Ensure you have a description field
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _deleteQuiz(quizId);
                          },
                        ),
                        onTap: () {
                          // Navigate to the QuizAttemptScreen when a quiz is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizAttemptScreen(quizId: quizId), // Create this screen
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
