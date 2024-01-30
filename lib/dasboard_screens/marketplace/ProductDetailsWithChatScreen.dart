// product_details_with_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatpage.dart';
import 'product.dart';
import 'buy_now_page.dart';

class ProductDetailsWithChatScreen extends StatelessWidget {
  final Product product;
  final String currentUserId;
  final String sellerEmail;

  ProductDetailsWithChatScreen({
    required this.product,
    required this.currentUserId,
    required this.sellerEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text(
          'Product Details',
          style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: 411.4,
            height: 770.3,
            alignment: Alignment.center,
          ),
          SingleChildScrollView(
            child: Stack(
              children: [

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color: Colors.grey[700]!,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 120.0),
                        child: Image.network(
                          product.imageUrl ?? 'No Image',
                          height: 200,
                          width: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name ?? 'Default Name',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 40, color: Colors.amber),
                            ),
                            Text(
                              '\$${product.price.toString()}',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 28, color: Colors.grey),
                            ),
                            // Display seller's email
                            Text(
                              'Seller Email: $sellerEmail',
                              style: GoogleFonts.bebasNeue(fontSize: 25, color: Colors.white),
                            ),
                            // Display product description
                            Text(
                              'Description: ',
                              style:
                              GoogleFonts.bebasNeue(fontSize: 35, color: Colors.amber),
                            ),
                            Text(
                              '${product.description ?? 'No Description'}',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Divider(),
                            GestureDetector(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    ' Chat with Seller!',
                                    style: GoogleFonts.bebasNeue(
                                        fontSize: 40, color: Colors.amber),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.message,
                                      color: Colors.amber, size: 40),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      receiverUserEmail: sellerEmail, // Provide the seller's email as the receiverUserEmail
                                    ),
                                  ),
                                );
                              },
                            ),
                            Divider(),
                            SizedBox(height: 100,),
                            Divider(),
                            GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(130.0,0,100.0,0),
                                child: Row(
                                  children: [
                                    Text("Buy Now!",style: GoogleFonts.bebasNeue(color: Colors.amber,fontSize: 30),),
                                    SizedBox(width: 20,),
                                    Icon(Icons.shopping_cart,color: Colors.amber,size: 30),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BuyNowPage(),
                                  ),
                                );
                              },

                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
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