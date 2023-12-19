import 'package:flutter/material.dart';

import '../reusable_widgets/custom_scaffold2.dart';
class MarketPlaceScreen extends StatelessWidget {
  const MarketPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: Center(child: Text('MarketPlace',style: TextStyle(color: Colors.amber,fontSize: 60),)),
    );
  }
}