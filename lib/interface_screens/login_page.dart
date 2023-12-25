//user login page
import 'package:iconsax/iconsax.dart';

import '../../reusable_widgets/reusable_widget.dart';
import 'package:fblogin/reusable_widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forgot_pw_page.dart';
//import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  //authenticates with firebase and returns a user
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Login successful message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login successful!',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.green,
        ),
      );

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

  //for memory management
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      //backgroundColor: Colors.grey[300],
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.0001, 20, 0,
                  ),
                  child: Image.asset("assets/images/logo.png",height:295,),
                ),


                //Sign in to continue text
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text(
                    "Sign In To Continue: ",
                    style: TextStyle(
                      color: Colors.amber[600],
                      fontSize: 32,
                      fontFamily: 'RobotoCondensed',
                      //letterSpacing: 1
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 25),


                //email textbox
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: reusableTextField("Email-Address", Iconsax.profile_circle, false, _emailController),
                ),
                SizedBox(
                  height: 20,
                ),


                //password textbox
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: reusableTextField("Password", Iconsax.lock, true, _passwordController),
                ),
                SizedBox(
                  height: 10,
                ),


                //forgot password text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPaswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.amber,

                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                //login in button
                MaterialButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'LOG IN',
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
                SizedBox(
                  height: 25,
                ),

                //bottom text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Text(
                        'Register now!',
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold,fontSize: 15),
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