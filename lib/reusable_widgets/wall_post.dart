import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/reusable_widgets/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String messsage;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost({Key? key, required this.messsage, required this.user, required this.postId, required this.likes})
      : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    //access doc in firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
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
                width: 2.0, // Adjust the border width as needed
              ),
            ),
            child: Icon(
              Icons.person,
              size: 23,
              color: Colors.amber,
            ),
          ),


          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user, style: TextStyle(color: Colors.amber, fontSize: 25, fontFamily: 'RobotoCondensed')),
                SizedBox(height: 10),
                Text(
                  widget.messsage,
                  style: TextStyle(color: Colors.white, fontSize: 19, fontFamily: 'RobotoCondensed'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 50,),
          Column(
            //like button
            children: [
              LikeButton(
                isLiked: isLiked,
                onTap: toggleLike,
              ),
              //like counter
              SizedBox(height: 5),
              Text(widget.likes.length.toString(), style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
