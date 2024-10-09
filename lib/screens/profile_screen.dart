import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'flashcard_screen.dart';
import 'manual_flashcard_set_screen.dart';
import 'quiz_attempt_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _profileImageUrl;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData(); // Load user data on initialization
  }

  // Load the user data from Firestore
  Future<void> _loadUserData() async {
    if (_user != null) {
      var userData = await _firestore.collection('users').doc(_user!.uid).get();
      setState(() {
        _profileImageUrl = userData['profileImageUrl'];
        print('Fetched Profile Image URL: $_profileImageUrl'); // Debugging line
      });
    }
  }

  // Upload profile image to Firebase Storage
  Future<void> _uploadProfileImage() async {
    if (_profileImage != null) {
      if (_user != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${_user!.uid}.jpg');
        await ref.putFile(_profileImage!);
        String url = await ref.getDownloadURL();

        // Update Firestore with the new profile image URL
        await _firestore.collection('users').doc(_user!.uid).update({
          'profileImageUrl': url,
        });

        setState(() {
          _profileImageUrl = url; // Update the state with the new URL
        });

        print('Uploaded Image URL: $url'); // Debugging line
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
    await _loadUserData(); // Fetch updated user data including profile image URL
  }

  // Fetch the user's flashcard sets from Firestore
  Stream<QuerySnapshot> _getFlashcardSets() {
    return _firestore
        .collection('flashcardSets')
        .where('userId', isEqualTo: _user?.uid)
        .snapshots();
  }

  // Fetch the user's quizzes from Firestore
  Stream<QuerySnapshot> _getQuizzes() {
    return _firestore
        .collection('quizzes')
        .where('userId', isEqualTo: _user?.uid)
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

  // Log out the user
  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, 'login'); // Navigate to the login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, 'Home'),
        ),
        title: Text('User Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout, // Log out functionality
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManualFlashcardSetScreen(),
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
                  Navigator.pop(context, 'home');
                },
                icon: const Icon(Icons.home, color: Colors.amber),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context, 'profile');
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
                  backgroundImage: (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                      ? NetworkImage(_profileImageUrl!)
                      : AssetImage('assets/placeholder.png') as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.camera_alt, color: Colors.amber, size: 30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                _user?.email ?? 'No email available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'My Flashcard Sets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getFlashcardSets(),
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
                        title: Text(flashcardSet['setTitle']?.toString() ?? 'No Title'),
                        subtitle: FutureBuilder<QuerySnapshot>(
                          future: _firestore
                              .collection('flashcardSets')
                              .doc(flashcardSetId)
                              .collection('flashcards')
                              .get(),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardScreen(flashcardSetId: flashcardSetId),
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
                stream: _getQuizzes(),
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
                      String quizId = quizzes[index].id;

                      return ListTile(
                        title: Text(quiz['quizTitle']?.toString() ?? 'No Title'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _deleteQuiz(quizId);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizAttemptScreen(quizId: quizId),
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
