import 'package:flutter/material.dart';

import '../reusable_widgets/custom_scaffold2.dart';
class PcBuilderScreen extends StatelessWidget {
  const PcBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Center(child: Text('PC-Builder',style: TextStyle(color: Colors.amber,fontSize: 60))),
    );
  }
}
