import 'package:fblogin/dasboard_screens/marketplace/ProductDetailsWithChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product.dart'; // Import the Product class

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

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
        leading: Image.network(product.imageUrl, width: 100, height: 100),
        title: Text(product.name, style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.amber)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${product.price.toString()}', style: GoogleFonts.bebasNeue(color: Colors.grey[700], fontSize: 24)),
            Text('Seller: ${product.sellerId ?? 'Unknown'}', style: GoogleFonts.bebasNeue(fontSize: 16)),
            Text('Description:',style: GoogleFonts.bebasNeue(fontSize: 24,color: Colors.amber),),
            Text('${product.description}', style: GoogleFonts.bebasNeue(fontSize: 22, color: Colors.grey)), // Display the description
          ],
        ),
        onTap: () async {
          final User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            final currentUserId = user.uid;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsWithChatScreen(product: product, currentUserId: currentUserId),
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
