import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/community/reWidgets/my_post_button.dart';
import 'package:fblogin/dasboard_screens/community/models/wall_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../reusable_widgets/reusable_widget.dart';

class CommunityScreen extends StatefulWidget {
  CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });

      setState(() {
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          'OCTAGRAM',
          style: GoogleFonts.bebasNeue(
            color: Colors.amber,
            fontSize: 40,
            letterSpacing: 6,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text(
                  'Signed in as: ' + currentUser.email!,
                  style: TextStyle(color: Colors.white, fontFamily: 'RobotoCondensed', fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: reusableTextField("Say Something", Icons.speaker_notes, false, textController),
                      ),
                      PostButton(onTap: postMessage),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .orderBy("TimeStamp", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          reverse: false,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return WallPost(
                              messsage: post['Message'],
                              user: post['UserEmail'],
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                              postTime: post['TimeStamp'], // Include the post time
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
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
