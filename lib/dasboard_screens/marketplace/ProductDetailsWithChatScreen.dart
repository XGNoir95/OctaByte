
import 'package:flutter/material.dart';


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
        title: Text('Product Details'),
        centerTitle: true,
      ),
      body:
      SingleChildScrollView(
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
                  Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('\$${product.price.toString()}', style: TextStyle(fontSize: 18)),

                ],
              ),
            ),
            Divider(),
            ChatBox(),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => MarketPlaceScreen()),
      //       );
      //     },
      //     child: Text('Back to Marketplace'),
      //   ),
      // ),
    );
  }
}
