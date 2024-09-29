import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for FirebaseAuth
import 'package:firebase_core/firebase_core.dart'; // Import for Firebase Core
import 'screens/login_screen.dart'; // Import for LoginScreen
import 'screens/home_screen.dart'; // Import for HomeScreen
import 'screens/create_flashcard_screen.dart'; // Import for CreateFlashcardScreen
import 'screens/manual_quiz_screen.dart';  // Add this line
import 'screens/manual_flashcard_set_screen.dart';  // Add this line


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  // Check if the user is already logged in
  FirebaseAuth auth = FirebaseAuth.instance;
  Widget defaultHome = auth.currentUser != null ? HomeScreen() : LoginScreen(); // Determine the default home

  runApp(MyApp(defaultHome: defaultHome));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;

  MyApp({required this.defaultHome}); // Constructor for default home

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashlearn',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: defaultHome, // Set the home screen here
      routes: {
        'home': (context) => HomeScreen(),
        'createFlashcard': (context) => CreateFlashcardScreen(), // Define create flashcard route
        'manualFlashcardSet': (context) => ManualFlashcardSetScreen(),
        'manualQuiz': (context) => ManualQuizScreen(),

        // No need to define the root route (/) since home is already specified
      },
    );
  }
}
