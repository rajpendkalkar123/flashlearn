import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text('Flashcards Added: 37'),
            Text('Hours Spent: 122+'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for logout
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
