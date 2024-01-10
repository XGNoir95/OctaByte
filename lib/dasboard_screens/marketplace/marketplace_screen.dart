import 'package:flutter/material.dart';

import '../../navigation_menu.dart';
import 'product.dart';
import 'product_Item_Widget.dart';

class MarketPlaceScreen extends StatelessWidget {
  const MarketPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> products = [
      Product(
        name: 'Product 1',
        imageUrl: 'https://media.cnn.com/api/v1/images/stellar/prod/keychron-q1-pro-qmk-via-wireless-custom-mechanical-keyboard-75-layout-full-aluminum-black-frame-for-mac-w-indows-linux-with-rgb-backlight-and-hot-swappable-k-pro-switch-banana-1800x1800.jpg?c=16x9&q=h_720,w_1280,c_fill',
        price: 19.99,
      ),
      Product(
        name: 'Product 2',
        imageUrl: 'https://www.tahaeshop.com/storage/a4tech/a4tech-krs-83-usb-keyboard-01.jpeg',
        price: 29.99,
      ),
      Product(
        name: 'Product 3',
        imageUrl: 'https://static-01.daraz.lk/p/b7613c4958782c1965f2051b6fc90987.jp',
        price: 29.99,
      ),
      Product(
        name: 'Product 4',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrW70D7v_ghpKXBJWs7Xez4vohezemPQ7E5g&usqp=CAU',
        price: 29.99,
      ),
      Product(
        name: 'Product 5',
        imageUrl: 'https://static-01.daraz.lk/p/b7613c4958782c1965f2051b6fc90987.jpg',
        price: 29.99,
      ),
      Product(
        name: 'Product 6',
        imageUrl: 'https://1.bp.blogspot.com/-6HV7kuziOHI/XThjLmTddAI/AAAAAAAAAHI/9qYEJOXMlM0R99BTbrebSH415plWGIXVwCLcBGAs/s1600/Slide4.JPG',
        price: 29.99,
      ),
      Product(
        name: 'Product 7',
        imageUrl: 'https://ns1.full.am/uploads/posting_image/user_32001/product_311539/9d4854a2e0685f3b59d12ac1eb5baa75.jpg',
        price: 29.99,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Marketplace'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductItem(product: products[index]);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>NavigationMenu()),
            );
          },
          child: Text('Back to Dashboard'),
        ),
      ),
    );
  }
}
