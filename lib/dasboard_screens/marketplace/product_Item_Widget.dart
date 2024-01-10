
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ProductDetailsWithChatScreen.dart';
import 'product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.imageUrl,width: 100,height: 100),
      title: Text(product.name,style: GoogleFonts.bebasNeue(fontSize: 25,color: Colors.amber)),
      subtitle: Text('\$${product.price.toString()}',style: GoogleFonts.bebasNeue(color: Colors.grey[700],fontSize: 20)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsWithChatScreen(product: product),
          ),
        );
      },
    );
  }
}
