import 'package:flutter/material.dart';

import '../reusable_widgets/custom_scaffold2.dart';
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Center(child: Text('COMMUNITY',style: TextStyle(color: Colors.amber,fontSize: 50))),
    );
  }
}