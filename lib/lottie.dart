import 'dart:async';
import 'auth_screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class LottieAnimation extends StatefulWidget {
  const LottieAnimation({super.key});

  @override
  State<LottieAnimation> createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<LottieAnimation> {
  @override
  void initState(){
    super.initState();
    Timer( const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const MainPage())));
    });
  }
  @override

  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/Octabyte.json"),
        ],
      ),
    );
  }
}


