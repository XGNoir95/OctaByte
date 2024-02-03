import 'package:fblogin/dasboard_screens/pc_builder/models/component_screen.dart';
import 'package:flutter/material.dart';
import 'package:fblogin/navibar_screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class CasingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComponentScreen(collectionName: "casing");
  }
}