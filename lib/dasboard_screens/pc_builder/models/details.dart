import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/pc_builder/collection_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  final String appBarTitle;

  ProductDetails(this._product, {required this.appBarTitle});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<Map<String, dynamic>> collection = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        actions: [
          MaterialButton(
            onPressed: () => navigateToCollectionPage(widget.appBarTitle),
            child: Icon(Icons.collections, color: Colors.amber, size: 28),
          )
        ],
        title: Text('Product Details',
            style: GoogleFonts.bebasNeue(fontSize: 40, color: Colors.amber)),
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
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Image.network(
                        widget._product['product-img'],
                        height: 300,
                        width: 300,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget._product['product-name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.amber),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About the product:',
                            style: GoogleFonts.bebasNeue(
                                color: Colors.amber, fontSize: 30),
                          ),
                          Text(
                            widget._product['product-description'],
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        Text(
                          "${widget._product['product-price'].toString()}",
                          style: GoogleFonts.bebasNeue(
                              //fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: 35,
                              color: Colors.amber),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        MaterialButton(
                          onPressed: saveToCollection,
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.amber,
                              ),
                              Text('Add to collection',
                                  style: GoogleFonts.bebasNeue(
                                      color: Colors.amber, fontSize: 27)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveToCollection() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userEmail = user.email;
        final appBarTitle = widget.appBarTitle;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .collection('collections')
            .doc(appBarTitle) // Set the document ID to appBarTitle
            .set(widget._product); // Use set instead of add

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Product saved to collection!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not authenticated!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving product to collection!'),
        ),
      );
      print('Error: $e');
    }
  }

  void navigateToCollectionPage(String appBarTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionPage(
          appBarTitle: appBarTitle,
        ),
      ),
    );
  }
}
