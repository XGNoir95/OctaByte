import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/navibar_screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComponentScreen extends StatefulWidget {
  final String collectionName;

  const ComponentScreen({Key? key, required this.collectionName}) : super(key: key);

  @override
  _ComponentScreenState createState() => _ComponentScreenState();
}

class _ComponentScreenState extends State<ComponentScreen> {
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection(widget.collectionName).get();
    setState(() {
      _products = qn.docs
          .map((doc) => {
        "product-name": doc["product-name"],
        "product-description": doc["product-description"],
        "product-price": doc["product-price"],
        "product-img": doc["product-img"],
      })
          .toList();
    });
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text(
          widget.collectionName.capitalize(), // Assumes you have a capitalize() method
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
          ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                  // MaterialPageRoute(builder: (_) => ProductDetails(_products[index])),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey[800]!, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.network(
                              _products[index]["product-img"],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_products[index]["product-name"]}",
                                style: GoogleFonts.bebasNeue(fontSize: 27),
                              ),
                              Text(
                                "${_products[index]["product-price"].toString()}",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
