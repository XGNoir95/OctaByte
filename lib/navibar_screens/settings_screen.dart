import 'package:flutter/material.dart';

import '../reusable_widgets/custom_scaffold2.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
        child: Center(child: Text("bye",style: TextStyle(fontSize: 40,color: Colors.white),))
    );
  }
}
