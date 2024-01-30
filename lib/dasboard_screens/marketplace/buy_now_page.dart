// buy_now_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/marketplace/product_Item_Widget.dart';
import 'product.dart';


class BuyNowPage extends StatefulWidget {
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



  void _proceedToPayment() async {
    bool paymentSuccessful = true;

    if (paymentSuccessful) {


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



}
