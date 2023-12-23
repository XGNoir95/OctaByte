//user register page

import 'package:fblogin/reusable_widgets/custom_scaffold2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../reusable_widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';


class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();


  //for memory management
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }
  //trim for formatting

  //creates a user
  Future signUp() async {
    try {
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        addUserDetails(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _userNameController.text.trim(),
          _emailController.text.trim(),
        );

        // Registration successful message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration successful!',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Passwords don't match message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Passwords do not match!',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future addUserDetails(String firstName, String lastName, String userName,String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'First Name': firstName,
      'Last Name': lastName,
      'User Name': userName,
      'Email': email
    });
  }

  //checks if password===confirmed pass
  bool passwordConfirmed(){
    if(_passwordController.text.trim() == _confirmpasswordController.text.trim()){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      //backgroundColor: Colors.grey[300],
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [


            //Enter info text
            SizedBox(height: 70,),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                "  Enter User Information:  ",
                style: TextStyle(
                  color: Colors.amber[600],
                  fontSize: 38,
                  fontFamily: 'RobotoCondensed',
                  //letterSpacing: 1
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),


            //first name textbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: reusableTextField("First Name", Icons.person_outline, false, _firstNameController),
            ),
            SizedBox(
              height: 20,
            ),

            //last name textbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: reusableTextField("Last Name", Icons.person_outline, false, _lastNameController),
            ),
            SizedBox(
              height: 20,
            ),

            //username textbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: reusableTextField("User Name", Icons.psychology_outlined, false, _userNameController),
            ),
            SizedBox(
              height: 20,
            ),

            //email textbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: reusableTextField("Email Address", Icons.mail_lock_outlined, false, _emailController),
            ),
            SizedBox(
              height: 20,
            ),

            //password textbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: reusableTextField("Password", Icons.lock_outline, true, _passwordController),
            ),
            SizedBox(
              height: 20,
            ),

            //confirm password textbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: reusableTextField("Confirm Password", Icons.lock_clock_outlined, true, _confirmpasswordController),
            ),
            SizedBox(
              height: 25,
            ),

            //sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: signUp,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'RobotoCondensed',
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //bottom text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a member? ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
                GestureDetector(
                  onTap: widget.showLoginPage,
                  child: Text(
                    'Login Now!',
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold,fontSize: 16),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}