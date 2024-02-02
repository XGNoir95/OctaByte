import 'package:fblogin/dasboard_screens/marketplace/products/ProductDetailsWithChatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fblogin/dasboard_screens/marketplace/products/product.dart';
//import 'package:fblogin/dasboard_screens/marketplace/product_details_with_chat.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final String sellerEmail;

  ProductItem({required this.product, required this.sellerEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[700]!,
          width: 2.0,
        ),
      ),
      child: ListTile(
        leading: Image.network(product.imageUrl, fit: BoxFit.cover,width: 100, height: 300),
        title: Text(product.name, style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.amber)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${product.price.toString()}', style: GoogleFonts.bebasNeue(color: Colors.grey, fontSize: 24)),
            Text('Seller: ${product.sellerId ?? 'Unknown'}', style: GoogleFonts.bebasNeue(fontSize: 22,color: Colors.white)),
            Text('Description:', style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.amber)),
            Text('${product.description}', style: GoogleFonts.bebasNeue(fontSize: 23, color: Colors.white)),
          ],
        ),
        onTap: () async {
          final User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            final currentUserId = user.uid;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsWithChatScreen(
                  product: product,
                  currentUserId: currentUserId,
                  sellerEmail: sellerEmail, // Pass the sellerEmail parameter
                ),
              ),
            );
          } else {
            print('User not authenticated');
          }
        },
      ),
    );
  }
}