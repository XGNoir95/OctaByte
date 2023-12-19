import 'package:flutter/material.dart';
class CustomScaffold2 extends StatelessWidget {
  const CustomScaffold2({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(padding: EdgeInsets.fromLTRB(60, MediaQuery.of(context).size.height*0.0005, 60, 0,),
            child: Image.asset("assets/images/logo.png",height: 300,),
          ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}