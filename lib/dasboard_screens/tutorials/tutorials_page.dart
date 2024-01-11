import 'package:fblogin/dasboard_screens/tutorials/tutorials_screen2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tutorials_screen.dart';
import 'tutorials_screen2.dart';

class TutorialsPage extends StatelessWidget {
  const TutorialsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          'OCTAHUB',
          style: GoogleFonts.bebasNeue(
            color: Colors.amber,
            fontSize: 40,
            letterSpacing: 6,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialsScreen()),
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Image.asset('assets/banner/thumb.jpg', width: 300, height: 350),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialsScreen2()),
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Image.asset('assets/banner/thumb2.jpg', width: 300, height: 350),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
