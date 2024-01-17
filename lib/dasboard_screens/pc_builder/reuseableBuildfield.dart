import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class buildCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const buildCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[700]!,
            width: 2.0,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Image.asset(imagePath, height: 80,color: Colors.white38),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                color: Colors.amber,
                fontFamily: 'RobotoCondensed',
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(primary: Colors.grey[700]),
              child: Text(
                'Select',
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

