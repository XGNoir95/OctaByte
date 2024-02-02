import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text(
          'Purchase History',
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
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (userSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${userSnapshot.error}'),
                );
              }

              if (!userSnapshot.hasData || userSnapshot.data == null) {
                return Center(
                  child: Text('User not signed in.'),
                );
              }

              User? currentUser = userSnapshot.data;

              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser?.email)
                    .collection('purchases')
                    .snapshots(),
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

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No purchase history available.'),
                    );
                  }

                  // Display the purchase history
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
                      Map<String, dynamic> purchaseData = doc.data()!;
                      // Customize the UI based on your purchase data structure
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16.0), // Add space between lists
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10.0), // Add circular border around the edges
                            border: Border.all(
                              color: Colors.grey[700]!,
                              width: 2.0,
                            ),
                          ),
                          child: ListTile(
                            //title:
                            subtitle: Row(
                              children: [
                                Image.network(
                                  purchaseData['Product Image'] ?? 'No Image',
                                  fit: BoxFit.contain,
                                  height: 100, // Adjust the height as needed
                                  width: 50, // Adjust the width as needed
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Product Name: ', style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 25)),
                                        Text('${purchaseData['Product Name']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Price: ', style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 25)),
                                        Text('${purchaseData['Product Price']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                                      ],
                                    ),
                                    // Column(
                                    //   children: [
                                    //     Text('Purchased on: ', style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 25)),
                                    //     Text('${purchaseData['Timestamp']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                                    //   ],
                                    // ),
                                    // Display the image using Image.network
                                  ],
                                ),
                              ],
                            ),
                            // Add more details as needed
                          ),
                        ),
                      );
                    }).toList(),
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