import 'package:firebase_core/firebase_core.dart';
import 'package:flashlearn/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for FirebaseAuth
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_flashcard_screen.dart';
import 'screens/manual_flashcard_screen.dart';
import 'screens/flashcard_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart'; // Import for SignupScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is already logged in
  FirebaseAuth auth = FirebaseAuth.instance;
  Widget defaultHome = auth.currentUser != null ? HomeScreen() : LoginScreen();

  runApp(MyApp(defaultHome: defaultHome));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;

  MyApp({required this.defaultHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashlearn',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: defaultHome, // Use the home property for the default screen
      routes: {
        'home': (context) => HomeScreen(),
        'createFlashcard': (context) => CreateFlashcardScreen(),
        'manualFlashcard': (context) => ManualFlashcardScreen(),
        'flashcardList': (context) => FlashcardListScreen(),
        'profile': (context) => ProfileScreen(),
        'signup': (context) => SignupScreen(), // Include the SignupScreen route
      },
    );
  }
}
