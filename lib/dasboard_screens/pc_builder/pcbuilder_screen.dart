import 'package:fblogin/dasboard_screens/pc_builder/reuseableBuildfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../reusable_widgets/custom_scaffold2.dart';

class PcBuilderScreen extends StatefulWidget {
  const PcBuilderScreen({super.key});

  @override
  State<PcBuilderScreen> createState() => _PcBuilderScreenState();
}

class _PcBuilderScreenState extends State<PcBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.grey[900],
          elevation: 0,
          title: Text(
            'OCTABUILDER',
            style: GoogleFonts.bebasNeue(
              color: Colors.amber,
              fontSize: 40,
              letterSpacing: 6,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    color: Colors.grey[800],
                    child: Text(
                      '  Core-Components:                            ',
                      style: GoogleFonts.bebasNeue(
                          color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                buildCard(
                  title: 'CPU',
                  imagePath: 'assets/builder/cpu.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Motherboard',
                  imagePath: 'assets/builder/motherboard.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'RAM',
                  imagePath: 'assets/builder/RAM.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Storage',
                  imagePath: 'assets/builder/storagex.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Graphics Card',
                  imagePath: 'assets/builder/gcard.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Power-Supply',
                  imagePath: 'assets/builder/power.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Container(
                    color: Colors.grey[800],
                    child: Text(
                      '  Peripheral-Components:                            ',
                      style: GoogleFonts.bebasNeue(
                          color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                buildCard(
                  title: 'Monitor',
                  imagePath: 'assets/builder/monitor.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Keyboard',
                  imagePath: 'assets/builder/keyboard.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Mouse',
                  imagePath: 'assets/builder/mouse.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Headphones',
                  imagePath: 'assets/builder/hx.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
                buildCard(
                  title: 'Casing Coolers',
                  imagePath: 'assets/builder/cooler.png',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                ),
              ],
            ),
          ),
        ]));
  }
}
