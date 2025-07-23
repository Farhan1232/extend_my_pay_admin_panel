import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  Future<void> _navigateUser() async {
    await Future.delayed(const Duration(seconds: 2)); // Just for effect

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('admin_Access')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return;
      } else {
        await auth.signOut();
      }
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              'Extend My Pay Admin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.teal),
            const SizedBox(height: 10),
            const Text("Checking access...",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
