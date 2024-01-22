import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AddProductScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product', style: GoogleFonts.bebasNeue(fontSize: 35, color: Colors.amber)),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (validateForm()) {
                  saveProduct(context);
                  Navigator.pop(context);
                }
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  bool validateForm() {
    return true; // Add your validation logic here
  }

  void saveProduct(BuildContext context) {
    try {
      // Save the product to Firebase using userData
      FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text,
        'imageUrl': imageUrlController.text,
        'price': double.parse(priceController.text),
        'buyerName': widget.userData['User Name'], // Use buyer name from userData
      });

      // Clear the controllers
      nameController.clear();
      imageUrlController.clear();
      priceController.clear();
    } catch (error) {
      print('Error saving product: $error');
    }
  }
}
