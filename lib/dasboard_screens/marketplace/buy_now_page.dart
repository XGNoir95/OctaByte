// buy_now_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/marketplace/products/product_Item_Widget.dart';
import 'products/product.dart';


class BuyNowPage extends StatefulWidget {
  final String productId;
  final String productName;
  final double productPrice;


  BuyNowPage({
    required this.productId,
    required this.productName,
    required this.productPrice,
  });

  @override
  _BuyNowPageState createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  String selectedPaymentSystem = "COD"; // Default selected payment system
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController _productNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buy Now',
          style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(54.1),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Payment Information',
                  style: GoogleFonts.bebasNeue(fontSize: 40, color: Colors.white),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: selectedPaymentSystem,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentSystem = newValue!;
                    });
                  },
                  items: <String>['COD', 'BKASH', 'NAGAD', 'ROCKET', 'Card']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.grey)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                _buildCardFields(),
                _buildPhoneNumberField(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _proceedToPayment();
                    }
                  },
                  child: Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Selected Payment System: $selectedPaymentSystem',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFields() {
    return Column(
      children: [
        if (selectedPaymentSystem == 'Card') ...[
          TextFormField(
            controller: cardNumberController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Card Number',
              labelStyle: TextStyle(color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 16) {
                return 'Enter a valid 16-digit card number.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: expirationDateController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Expiration Date (MM/YYYY)',
              labelStyle: TextStyle(color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter a valid expiration date.';
              }
              RegExp regExp = RegExp(r'^\d{2}/\d{4}$');
              if (!regExp.hasMatch(value)) {
                return 'Enter a valid expiration date (MM/YYYY).';
              }
              List<String> parts = value.split('/');
              int month = int.tryParse(parts[0] ?? '') ?? 0;
              int year = int.tryParse(parts[1] ?? '') ?? 0;
              if (month < 1 || month > 12) {
                return 'Invalid month. Enter a value between 1 and 12.';
              }
              if (year < 2024 || year > 2034) {
                return 'Invalid year. Enter a value between 2024 and 2034.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: cvvController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'CVV',
              labelStyle: TextStyle(color: Colors.white),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 3) {
                return 'Enter a valid 3-digit CVV.';
              }
              return null;
            },
          ),
        ],
        TextFormField(
          controller: addressController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Home Address',
            labelStyle: TextStyle(color: Colors.white),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter your home address.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    if (['BKASH', 'NAGAD', 'ROCKET'].contains(selectedPaymentSystem)) {
      return TextFormField(
        controller: phoneNumberController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(color: Colors.white),
        ),
        validator: (value) {
          if (value == null || value.isEmpty || value.length != 11) {
            return 'Enter a valid 11-digit phone number.';
          }
          List<String> allowedPrefixes = ['017', '016', '019', '018', '015', '013'];
          if (!allowedPrefixes.any((prefix) => value.startsWith(prefix))) {
            return 'Enter valid phone number.';
          }
          return null;
        },
      );
    } else {
      return SizedBox();
    }
  }

  void _proceedToPayment() async {
    bool paymentSuccessful = true;

    if (paymentSuccessful) {
      //await savePaymentInfoToFirebase();

      // Save product information to Firebase after successful payment
      await saveProductInfoToFirebase();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Payment successful',
              style: TextStyle(color: Colors.black),
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> saveProductInfoToFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String documentId = user.email ?? '';

      // Get a reference to the user's products subcollection
      CollectionReference productsCollection = FirebaseFirestore.instance.collection('users').doc(documentId).collection('purchases');

      // Create a new document for each product with a unique ID
      DocumentReference newProductRef = productsCollection.doc();

      // Set the product information in the new document
      await newProductRef.set({
        'Product ID': widget.productId,
        'Product Name': widget.productName,
        'Product Price': widget.productPrice,
        'Timestamp': FieldValue.serverTimestamp(), // You can use this to track when the product was purchased
      });
    }
  }




}
