import 'package:fblogin/reusable_widgets/custom_scaffold3.dart';
import 'package:fblogin/user_screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold3(
      child: Center(
        child: ElevatedButton(
          child: Text("logout"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("signed out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
        ),
      ),
    );
  }
}
