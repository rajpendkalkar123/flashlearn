import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_flashcards_screen.dart';
import 'screens/manual_quiz_screen.dart';
import 'screens/manual_flashcard_set_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    runApp(const MyApp(defaultHome: ErrorScreen()));
    return; // Stop execution if Firebase fails to initialize
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  Widget defaultHome = auth.currentUser != null ? const HomeScreen() : LoginScreen();

  runApp(MyApp(defaultHome: defaultHome));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;

  const MyApp({super.key, required this.defaultHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashlearn',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: defaultHome,
      routes: {
        'home': (context) => const HomeScreen(),
        'createFlashcard': (context) => const CreateFlashcardScreen(),
        'manualFlashcardSet': (context) => const ManualFlashcardSetScreen(),
        'manualQuiz': (context) => const ManualQuizScreen(),
        'profile': (context) =>  ProfileScreen(),
        'manualQuizSet': (context) => const ManualQuizScreen(),
      },
    );
  }
}

// Error Screen to show if Firebase fails to initialize
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Text(
          'Failed to initialize Firebase. Please try again later.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
