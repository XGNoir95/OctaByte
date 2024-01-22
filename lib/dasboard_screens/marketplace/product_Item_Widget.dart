
import 'package:flutter/material.dart';
import 'ProductDetailsWithChatScreen.dart';
import 'product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.imageUrl),
      title: Text(product.name),
      subtitle: Text('\$${product.price.toString()}'),
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
