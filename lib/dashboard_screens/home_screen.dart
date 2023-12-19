
import 'package:flutter/material.dart';
import '../reusable_widgets/custom_scaffold2.dart';
// import 'package:octa_byte/user_screens/signin_screen.dart';
// import '../reusable_widgets/circular_widgets.dart';
// import '../reusable_widgets/reuseable_widget.dart';
// import '../utils/color_utils.dart';
// import 'package:octa_byte/capp_bar.dart';
//import 'package:octa_byte/capp_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Center(child: Text('HOME',style: TextStyle(color: Colors.amber,fontSize: 60),)),
    );
  }
}

