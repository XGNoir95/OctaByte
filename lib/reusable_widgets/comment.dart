import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    Key? key,
    required this.text,
    required this.user,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: Border.all(
          color: Colors.grey[600]!,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[900],
              border: Border.all(
                color: Colors.grey[900]!,
                width: 2.0,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 23,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 25),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'RobotoCondensed',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(" . "),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
