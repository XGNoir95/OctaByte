//forgot password ui
import 'package:fblogin/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../reusable_widgets/custom_scaffold2.dart';


class ForgotPaswordPage extends StatefulWidget {
  const ForgotPaswordPage({super.key});

  @override
  State<ForgotPaswordPage> createState() => _ForgotPaswordPageState();
}

class _ForgotPaswordPageState extends State<ForgotPaswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  //verification text and process
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      // Password reset link sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset link sent! Check your email.',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? 'An error occurred';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //restore password text
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(
              "Restore your Password: ",
              style: TextStyle(
                color: Colors.amber[600],
                fontSize: 40,
                fontFamily: 'RobotoCondensed',
                //letterSpacing: 1
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 45,),

          //enter email text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
                'Enter your Email and we will send you a password reset link:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23,color: Colors.white,fontFamily: 'RobotoCondensed,')),
          ),
          SizedBox(height: 25),


          // verify email textbox
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: reusableTextField("Email Address", Iconsax.profile_tick, false, _emailController),
          ),
          SizedBox(
            height: 25,
          ),

          //reset button
          ElevatedButton(
            onPressed: passwordReset,
            child: Text('Reset Password', style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 18,color: Colors.black,)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: Size(18, 50),
            ),
          )
        ],
      ),
    );
  }
}