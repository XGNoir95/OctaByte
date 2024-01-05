import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/database/firestore.dart';
import 'package:fblogin/reusable_widgets/my_post_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../reusable_widgets/reusable_widget.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController newpostController = TextEditingController();

  void postMessage() {
    if (newpostController.text.isNotEmpty) {
      String message = newpostController.text;
      database.addPost(message);
    }

    newpostController.clear();
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
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: reusableTextField("Say Something",
                          Icons.speaker_notes, false, newpostController),
                    ),
                    PostButton(onTap: postMessage),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: database.getPostsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final posts = snapshot.data!.docs;

                      if (snapshot.data == null || posts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: Text('No posts right now. Post Something!'),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                String message = post['PostMessage'];
                                String userEmail = post['UserEmail'];
                                Timestamp timestamp = post['TimeStamp'];

                                return Column(
                                  children: [
                                    Container(
                                      color: Colors.white.withOpacity(0.1),
                                      child: ListTile(
                                        title: Text(userEmail,
                                            style: TextStyle(
                                                color: Colors.amber, fontSize: 25,fontFamily: 'RobotoCondensed')),
                                        subtitle: Text(message,
                                            style: TextStyle(color: Colors.white,fontSize: 18)),
                                      ),

                                    ),
                                    SizedBox(height: 40,),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
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
