import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatpage.dart';

class Inbox extends StatelessWidget {
  const Inbox({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 255, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text('ByteTalk',
            style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40)),
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
          const inboxCollection(),
          ]
      ),
    );
  }
}

// ignore: camel_case_types
class inboxCollection extends StatelessWidget {
  const inboxCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection('inbox')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<String> items = snapshot.data!.docs.map((doc) => doc.id).toList();
        if (items.isEmpty) {
          return const Center(
            child: Text('No items found in the collection.'),
          );
        } else {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            children: [
              for (String receiver in items)
                Column(
                  children: [
                    InboxCard(receiverId: receiver),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
            ],
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class InboxCard extends StatelessWidget {
  String receiverId;
  InboxCard({super.key, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(receiverId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                          receiverUserEmail: receiverId,
                      )
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.person,size: 25,color: Colors.white,),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['User Name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.amber,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error${snapshot.error}"),
              );
            } else
              // ignore: curly_braces_in_flow_control_structures
              return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
