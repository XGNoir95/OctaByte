import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/community/models/comment.dart';
import 'package:fblogin/dasboard_screens/community/reWidgets/commentButton.dart';
import 'package:fblogin/dasboard_screens/community/models/helper.dart';
import 'package:fblogin/dasboard_screens/community/reWidgets/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String messsage;
  final String user;
  final String postId;
  final List<String> likes;
  final Timestamp postTime;

  const WallPost({
    Key? key,
    required this.messsage,
    required this.user,
    required this.postId,
    required this.likes,
    required this.postTime,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
    FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

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

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "commentBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment.."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(
          color: Colors.grey[800]!,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User icon, User info, and Post
            Row(
              children: [
                Container(
                  width: 40,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[800],
                    border: Border.all(
                      color: Colors.grey[800]!,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              widget.user,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 25,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text(
                            formatDate(widget.postTime),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'RobotoCondensed',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              widget.messsage,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'RobotoCondensed',
                              ),
                            ),
                          ),
                          // Add any additional widgets here if needed
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Like and Comment options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    LikeButton(
                      isLiked: isLiked,
                      onTap: toggleLike,
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.likes.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    CommentButton(onTap: showCommentDialog),
                    SizedBox(height: 5),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<DocumentSnapshot> commentDocs =
                            snapshot.data!.docs;
                        int commentCount = commentDocs.length;
                        return Text(
                          commentCount.toString(),
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Comments displayed
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<DocumentSnapshot> commentDocs = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int index = 0; index < commentDocs.length; index++)
                        Comment(
                          text: commentDocs[index]["CommentText"],
                          user: commentDocs[index]["commentBy"],
                          time: formatDate(commentDocs[index]["CommentTime"]),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
