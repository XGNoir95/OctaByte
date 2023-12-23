import 'package:flutter/material.dart';
import '../interface_screens/login_page.dart';
import '../interface_screens/register_page.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially show the login page
  bool showLoginPage = true;


  //will toggle b/w login and register screen
  void toggleScreens(){
    setState((){
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(showRegisterPage : toggleScreens);
    } else{
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
