import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text('Flashcards Added: 37'),
            const Text('Hours Spent: 122+'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for logout
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
