import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for FirebaseAuth

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle user sign-in
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // On successful login, navigate to Home Screen
      Navigator.pushReplacementNamed(context, 'home');
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Function to handle user registration
  Future<void> _createUserWithEmailAndPassword(BuildContext context) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // On successful registration, navigate to Home Screen
      Navigator.pushReplacementNamed(context, 'home');
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email or Username',
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFBD4A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      _signInWithEmailAndPassword(context);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Don't Have An Account?",
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    // Call the create user function here
                    _createUserWithEmailAndPassword(context);
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'OR',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      'lib/assets/images/img.png',
                      height: 24,
                      width: 24,
                    ),
                    label: Text(
                      'Login with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      side: BorderSide(color: Colors.grey),
                    ),
                    onPressed: () {
                      // Placeholder for Google Sign-In logic
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
