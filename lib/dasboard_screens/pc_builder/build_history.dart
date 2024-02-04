import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/pc_builder/pcbuilder_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PastBuildsPage extends StatelessWidget {
  // Function to read data from the 'Builds' collection
  Future<List<List<Map<String, dynamic>>>> readFromBuildsCollection(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userEmail = user.email;

        // Check if the user email is available
        if (userEmail != null) {
          // Reference to the user's document
          final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(userEmail);

          // Get the documents from the 'Builds' collection
          final buildsQuerySnapshot = await userDocumentRef.collection('Builds').get();

          // Extract data from each document in the collection
          final buildsData = buildsQuerySnapshot.docs.map<List<Map<String, dynamic>>>((buildDoc) {
            final data = buildDoc.data() as Map<String, dynamic>;
            final collection = data['collection'] as List<dynamic>;
            return List<Map<String, dynamic>>.from(collection);
          }).toList();

          return buildsData;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User email is null!'),
            ),
          );
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not authenticated!'),
          ),
        );
        return [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error reading collection from Builds!'),
        ),
      );
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text(
          'Past Builds',
          style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40),
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
          FutureBuilder<List<List<Map<String, dynamic>>>>(
            future: readFromBuildsCollection(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final buildsData = snapshot.data ?? [];

              if (buildsData.isEmpty) {
                return Center(
                  child: Text('No past builds available.', style: TextStyle(color: Colors.white)),
                );
              }

              return ListView.builder(
                itemCount: buildsData.length,
                itemBuilder: (context, index) {
                  final buildData = buildsData[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuildDetailsPage(buildData: buildData),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 2.0,
                          ),
                        ),
                        child: ListTile(
                          title: Text('Build ${index + 1}', style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 30)),
                          // Customize the display of each build as needed
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PcBuilderScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
class BuildDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> buildData;

  BuildDetailsPage({required this.buildData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text(
          'Build details',
          style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Products:', style: GoogleFonts.bebasNeue(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.amber)),
              ),
              for (var product in buildData) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(
                          color: Colors.grey[800]!,
                          width: 2.0,
                        )),
                    child: ListTile(
                      //title:
                      subtitle: Row(
                        children: [
                          Image.network(product['product-img'],height: 80,width: 80,),
                          SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text('${product['product-name']}',style: GoogleFonts.bebasNeue(color: Colors.amber,fontSize: 24)),
                                Text('Price: ${product['product-price']}',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Customize the display of each product as needed
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

