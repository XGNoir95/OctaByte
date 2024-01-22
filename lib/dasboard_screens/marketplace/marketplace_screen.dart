
import 'package:fblogin/dasboard_screens/marketplace/product_Item_Widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../navigation_menu.dart';
import 'product.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({Key? key}) : super(key: key);

  @override
  _MarketPlaceScreenState createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  File? _imageFile;

  void uploadProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Upload a new product',
                      style: GoogleFonts.bebasNeue(fontSize: 34, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _productPriceController,
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _productDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Product Description',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  _imageFile == null
                      ? Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _pickImage();
                      },
                      child: Text('Pick Image', style: TextStyle(color: Colors.black)),
                    ),
                  )
                      : Image.file(_imageFile!, height: 100, width: 100),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _uploadProduct();
                      },
                      child: Text('Upload', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text('Marketplace',
            style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    List<Product> products = snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                      // Handle potential null values
                      String productName = data['name']?.toString() ?? 'Default Name';
                      String imageUrl = data['imageUrl']?.toString() ?? 'No Image';
                      String description = data['description']?.toString() ?? 'No Description';
                      double price = (data['price'] as num?)?.toDouble() ?? 0.0;
                      String sellerId = data['sellerId']?.toString() ?? 'Unknown'; // Get the seller's email

                      return Product(
                        id: doc.id,
                        name: productName,
                        imageUrl: imageUrl,
                        price: price,
                        description: description,
                        chatRoomId: data['chatRoomId']?.toString() ?? 'Default Chat Room ID',
                        sellerId: sellerId,
                      );
                    }).toList();


                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: ProductItem(
                            product: products[index],
                            sellerEmail: products[index].sellerId, // Pass the seller's email from the product
                          ),
                        );
                      },
                    );

                  },
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 88,
                color: Colors.grey[900],
                child: Row(
                  children: [
                    SizedBox(width: 75,),
                    _buildProductUploadSection(),
                    SizedBox(width: 50,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductUploadSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Text('Upload a new product',
                style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.amber)),
            onTap: () => uploadProduct(context),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_productNameController.text.isEmpty ||
        _productPriceController.text.isEmpty ||
        _imageFile == null) {
      return;
    }

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('product_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);

      // Wait for the image upload to complete
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      // Check if the upload was successful
      if (taskSnapshot.state == TaskState.success) {
        // Get the image URL
        String imageUrl = await storageReference.getDownloadURL();

        // Get the current user
        final User? user = FirebaseAuth.instance.currentUser;

        // Add product details to Firestore along with the seller's email
        await FirebaseFirestore.instance.collection('products').add({
          'name': _productNameController.text,
          'price': double.parse(_productPriceController.text),
          'imageUrl': imageUrl,
          'description': _productDescriptionController.text,
          'sellerId': user?.email, // Include the seller's email
        });

        // Clear text controllers and image file after uploading
        _productNameController.clear();
        _productPriceController.clear();
        _productDescriptionController.clear();
        setState(() {
          _imageFile = null;
        });
        Navigator.pop(context); // Close the dialog after uploading
      } else {
        print('Error uploading image: Upload task not successful');
      }
    } catch (error) {
      print('Error uploading product: $error');
    }
  }
}