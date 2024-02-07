import 'package:fblogin/dasboard_screens/pc_builder/models/component_screen.dart';
import 'package:flutter/material.dart';
import 'package:fblogin/navibar_screens/notification/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadphoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComponentScreen(collectionName: "headphone",appBarTitle: "Headphones");
  }
}