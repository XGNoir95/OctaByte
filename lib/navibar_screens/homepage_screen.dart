import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/custom_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Show signed out success message using a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signed Out Successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Signed In as: ' + user.email!,
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 30,
                      color: Colors.amber)),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                _signOut(context); // Pass the context to the _signOut method
              },
              color: Colors.white,
              child: Text('Sign Out',
                  style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
