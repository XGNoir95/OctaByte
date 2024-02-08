import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../chat/chatpage.dart';
import 'product.dart';
import '../buy/buy_now_page.dart';

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
    void _showEnlargedImage() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[900],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Image.network(
                      product.imageUrl ?? 'No Image',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

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
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey[700]!,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: _showEnlargedImage,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                product.imageUrl ?? 'No Image',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          product.name ?? 'Default Name',
                          style: GoogleFonts.bebasNeue(fontSize: 40, color: Colors.amber),
                        ),
                        Divider(color: Colors.white),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '               About the product:',
                              style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.amber),
                            ),
                            Text(
                              '${product.description ?? 'No Description'}',
                              style: TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            SizedBox(height: 16),
                            Text(
                              '\$${product.price.toString()}',
                              style: GoogleFonts.bebasNeue(fontSize: 35, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Seller Email: ',
                                  style: GoogleFonts.bebasNeue(fontSize: 25, color: Colors.amber),
                                ),
                                Flexible(
                                  child: Text(
                                    ' $sellerEmail ',
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: Colors.white),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  receiverUserEmail: sellerEmail,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.message, color: Colors.amber),
                          label: Text('Chat with Seller', style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 25)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyNowPage(
                                  productId: product.id,
                                  productName: product.name,
                                  productPrice: product.price,
                                  productImageUrl: product.imageUrl ?? 'No Image',
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.shopping_cart, color: Colors.amber),
                          label: Text('Buy Now', style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 25)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
