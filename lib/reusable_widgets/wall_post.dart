import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/reusable_widgets/comment.dart';
import 'package:fblogin/reusable_widgets/commentButton.dart';
import 'package:fblogin/reusable_widgets/helper.dart';
import 'package:fblogin/reusable_widgets/like_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ... (previous imports)

class WallPost extends StatefulWidget {
  final String messsage;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.messsage,
    required this.user,
    required this.postId,
    required this.likes,
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
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
                Text(
                  widget.user,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.messsage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 50,
          ),
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
                      List<DocumentSnapshot> commentDocs = snapshot.data!.docs;
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
          StreamBuilder<QuerySnapshot>(
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

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: commentDocs.length,
                  itemBuilder: (context, index) {
                    final commentData = commentDocs[index].data() as Map<String, dynamic>;
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["commentBy"],
                      time: formatData(commentData["CommentTime"]),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
