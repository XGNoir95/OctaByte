import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ChatBox.dart';
import 'marketplace_screen.dart';
import 'product.dart';

class ProductDetailsWithChatScreen extends StatelessWidget {
  final Product product;

  ProductDetailsWithChatScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: GoogleFonts.bebasNeue(fontSize: 35, color: Colors.amber)),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[700], // Set to a lighter grey shade
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.network(product.imageUrl),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: GoogleFonts.bebasNeue(fontSize: 40, fontWeight: FontWeight.bold,letterSpacing: 0)),
                    Text('\$${product.price.toString()}', style: GoogleFonts.bebasNeue(fontSize: 28)),
                  ],
                ),
              ),
              Divider(),
              ChatBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MarketPlaceScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[800],
          ),
          child: Text('Back to Marketplace', style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 30)),
        ),
      ),
    );
  }
}
