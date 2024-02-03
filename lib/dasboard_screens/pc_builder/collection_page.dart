import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionPage extends StatelessWidget {
  final String appBarTitle;

  CollectionPage({required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('User not authenticated!'),
        ),
      );
    }

    final userEmail = user.email;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collections',
          style: GoogleFonts.bebasNeue(fontSize: 40, color: Colors.amber),
        ),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
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
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userEmail)
                .collection('collections')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<Map<String, dynamic>> collection = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return ListView.builder(
                itemCount: collection.length,
                itemBuilder: (context, index) {
                  var documentId = snapshot.data!.docs[index].id;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: Border.all(
                            color: Colors.grey[800]!,
                            width: 2.0,
                          )),
                      //color: Colors.grey[800],
                      child: ListTile(
                        title: Text(documentId,style: GoogleFonts.bebasNeue(color: Colors.white,fontSize: 30)), // Display document ID
                        subtitle: Row(
                          children: [
                            Image.network(collection[index]['product-img'], height: 80, width: 80),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(collection[index]['product-name'],style: GoogleFonts.bebasNeue(color: Colors.amber,fontSize: 25)),
                                  Text(collection[index]['product-price'].toString(),style: GoogleFonts.bebasNeue(color: Colors.white,fontSize: 28)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
