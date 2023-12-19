import 'package:flutter/material.dart';
//import 'package:octa_byte/user_screens/welcome_screen.dart';
import 'package:octabyte_main/user_screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}
class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SD Project',
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


