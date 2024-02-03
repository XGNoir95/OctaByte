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

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
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
                            child: ListTile(
                              title: Text(
                                documentId,
                                style: GoogleFonts.bebasNeue(
                                    color: Colors.white, fontSize: 30),
                              ),
                              subtitle: Row(
                                children: [
                                  Image.network(
                                    collection[index]['product-img'],
                                    height: 60,
                                    width: 60,
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          collection[index]['product-name'],
                                          style: GoogleFonts.bebasNeue(
                                              color: Colors.amber,
                                              fontSize: 22),
                                        ),
                                        Text(
                                          collection[index]['product-price']
                                              .toString(),
                                          style: GoogleFonts.bebasNeue(
                                              color: Colors.white,
                                              fontSize: 22),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => saveToBuildsCollection(context, collection),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(100, 50),
                            primary: Colors.grey[900], // Background color
                          ),
                          child: Text('Save', style: TextStyle(color: Colors.white,fontSize: 20)),
                        ),

                        ElevatedButton(
                          onPressed: () => clearCollection(context, userEmail),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(100, 50),
                            primary: Colors.grey[900],
                            // Background color
                          ),
                          child: Text('Clear', style: TextStyle(color: Colors.white,fontSize: 20)),
                        ),

                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void saveToBuildsCollection(BuildContext context, List<Map<String, dynamic>> collection) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userEmail = user.email;

        // Check if the user email is available
        if (userEmail != null) {
          // Reference to the user's document
          final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(userEmail);

          // Get the current count of documents in the 'Builds' collection
          final buildsQuerySnapshot = await userDocumentRef.collection('Builds').get();
          final currentDocumentCount = buildsQuerySnapshot.size;

          // Create a unique document ID based on the current count
          final buildDocumentId = 'build_$currentDocumentCount';

          // Add a new document to the 'Builds' collection with the unique ID
          await userDocumentRef.collection('Builds').doc(buildDocumentId).set({'collection': collection});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Collection saved to Builds with ID: $buildDocumentId',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User email is null!'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not authenticated!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving collection to Builds!'),
        ),
      );
      print('Error: $e');
    }
  }


  void clearCollection(BuildContext context, String? userEmail) async {
    try {
      // Clear the entire collection by deleting all documents
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('collections')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Collection cleared!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing collection!'),
        ),
      );
      print('Error: $e');
    }
  }
}
