import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:octa_byte/navigation_menu.dart';
// import 'package:octa_byte/reusable_widgets/reuseable_widget.dart';
// import 'package:octa_byte/dashboard_screens/home_screen.dart';
// import 'package:octa_byte/user_screens/signup_screen.dart';
// import 'package:octa_byte/utils/color_utils.dart';
// import 'package:octa_byte/reusable_widgets/custom_scaffold.dart';
import 'package:fblogin/user_screens/signup_screen.dart';

import '../navigation_menu.dart';
import '../reusable_widgets/custom_scaffold.dart';
import '../reusable_widgets/reusable_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // body: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [
      //         //hexStringToColor("2B2B2B"),
      //         //hexStringToColor("ff272626"),
      //         //hexStringToColor("ff1e1e1e"),
      //         hexStringToColor("2F2F32"),
      //         hexStringToColor("ff0f0d0d"),
      //         hexStringToColor("000000"),
      //       ],
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //     ),
      //   ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.0001, 20, 0,
            ),
            child: Image.asset("assets/images/logo.png",height:320,),
          ),
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

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),

                reusableTextField("Email-Address", Icons.person, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Password", Icons.lock, true, _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    print("Logged in Successfully");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            NavigationMenu()));
                  }).onError((error, stackTrace){
                    print("Incorrect Email or Password entered ${error.toString()}");
                  });
                }),
                signUpOption(),
              ],
            ),
          ),
        ],
      ),
    );
    //);
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?", style: TextStyle(fontSize: 18,color: Colors.white70,fontFamily: 'RobotoCondensed',)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign-Up",
            style: TextStyle(fontSize: 18,color: Colors.amber, fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed',letterSpacing: 1),
          ),
        )
      ],
    );
  }
}