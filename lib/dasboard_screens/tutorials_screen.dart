import 'package:flutter/material.dart';

import '../reusable_widgets/custom_scaffold2.dart';
class TutorialsScreen extends StatelessWidget {
  const TutorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Center(child: Text('TUTORIALS',style: TextStyle(color: Colors.amber,fontSize: 60))),
    );
  }
}