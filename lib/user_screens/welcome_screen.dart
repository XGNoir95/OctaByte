import 'package:fblogin/user_screens/signin_screen.dart';
import 'package:fblogin/user_screens/signup_screen.dart';
import 'package:flutter/material.dart';
// import 'package:octa_byte/user_screens/signin_screen.dart';
// import 'package:octa_byte/user_screens/signup_screen.dart';
// import 'package:octa_byte/reusable_widgets/reuseable_widget.dart';
// import 'package:octa_byte/reusable_widgets/custom_scaffold.dart';
// import 'package:octabyte_main/user_screens/signin_screen.dart';
// import 'package:octabyte_main/user_screens/signup_screen.dart';

import '../reusable_widgets/custom_scaffold.dart';
import '../reusable_widgets/reusable_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Image.asset('assets/images/logo.png',height: 300),
          Flexible(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome Back!',
                            style: TextStyle(
                              fontSize: 45.0,
                              //fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontFamily: 'RobotoCondensed',
                              color: Colors.amber,
                            )),
                        TextSpan(
                            text:
                            '\n\nEnjoy and have a personalized experience in a space of your own!',
                            style: TextStyle(
                              fontSize: 20,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'SIGN IN',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'SIGN UP',
                      onTap: const SignUpScreen(),
                      color: Colors.grey[850],
                      textColor: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}