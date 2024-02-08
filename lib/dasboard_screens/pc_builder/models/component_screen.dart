import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/pc_builder/pages/collection_page.dart';
import 'package:fblogin/navibar_screens/notification/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'details.dart';
import 'search_screen.dart';

class ComponentScreen extends StatefulWidget {
  final String collectionName;
  final String appBarTitle;

  const ComponentScreen(
      {Key? key, required this.collectionName, required this.appBarTitle})
      : super(key: key);

  @override
  _ComponentScreenState createState() => _ComponentScreenState();
}

class _ComponentScreenState extends State<ComponentScreen> {
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;
  bool showSearchResults = false;
  var inputText = "";

  fetchProducts() async {
    QuerySnapshot qn =
    await _firestoreInstance.collection(widget.collectionName).get();
    setState(() {
      _products = qn.docs
          .map((doc) =>
      {
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
          widget.appBarTitle,
          style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40),
        ),
        centerTitle: true,
        actions: [
          MaterialButton(
            onPressed: () => navigateToCollectionPage(widget.appBarTitle),
            child: Icon(Icons.collections, color: Colors.amber, size: 28),
          )
        ],
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
          Column(
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: "Search products here",
                              hintStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => SearchDialog(
                                  collectionName: widget.collectionName,
                                  onClose: () {
                                    setState(() {
                                      showSearchResults = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  navigateToCollectionPage: navigateToCollectionPage,
                                  products: [], // Pass the _products list here
                                  appBarTitle: widget.appBarTitle, // Pass the appBarTitle
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[800],
                      height: 60,
                      width: 50,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => SearchDialog(
                              collectionName: widget.collectionName,
                              onClose: () {
                                setState(() {
                                  showSearchResults = false;
                                });
                                Navigator.of(context).pop();
                              },
                              navigateToCollectionPage: navigateToCollectionPage,
                               // Pass the _products list here
                              appBarTitle: widget.appBarTitle, products: [], // Pass the appBarTitle
                            ),
                          );
                        },
                        child: Icon(
                          Icons.search,
                          size: 40,
                          color: Colors.amber,
                        ),
                      ),

                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: showSearchResults
                    ? Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(widget.collectionName)
                        .where("product-name",
                        isGreaterThanOrEqualTo: inputText)
                        .where("product-name",
                        isLessThan: inputText + 'z')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading"),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(data['product-name']),
                              leading: Image.network(data['product-img']),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                )
                    : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetails(_products[index],
                                          appBarTitle: widget.appBarTitle))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            border: Border.all(
                                color: Colors.grey[800]!, width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bg.jpg'),
                                      fit: BoxFit.fitWidth,
                                    ),
                                    color: Colors.grey[900],
                                    borderRadius:
                                    BorderRadius.circular(10.0),
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_products[index]["product-name"]}",
                                      style: GoogleFonts.bebasNeue(
                                          fontSize: 27,
                                          color: Colors.amber),
                                    ),
                                    Text(
                                      "${_products[index]["product-price"]
                                          .toString()}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  void navigateToCollectionPage(String appBarTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CollectionPage(
              appBarTitle: appBarTitle,
            ),
      ),
    );
  }
}





extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
