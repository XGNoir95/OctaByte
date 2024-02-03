import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/navibar_screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'details.dart';

class ComponentScreen extends StatefulWidget {
  final String collectionName;

  const ComponentScreen({Key? key, required this.collectionName})
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
          widget.collectionName.capitalize(),
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
                        child: Icon(
                          Icons.search,
                          size: 40,
                          color: Colors.amber,
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
                            ),
                          );
                        },
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
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetails(_products[index]))),
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
                                            "${_products[index]["product-price"].toString()}",
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
}

class SearchDialog extends StatefulWidget {
  final String collectionName;
  final VoidCallback onClose;

  const SearchDialog(
      {Key? key, required this.collectionName, required this.onClose})
      : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  var inputText = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            // Replace with the path to your image asset
            fit: BoxFit.cover, // Adjust the BoxFit property as needed
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  // Set the background color
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    //borderSide: BorderSide(color: Colors.amber),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: "What are you searching for Today?",
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(widget.collectionName)
                        .where("product-name",
                            isGreaterThanOrEqualTo: inputText)
                        .where("product-name", isLessThan: inputText + 'z')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading"),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                //color: Colors.grey[900],

                                decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    border: Border.all(
                                      color: Colors.grey[800]!,
                                      width: 2.0,
                                    )),

                                child: ListTile(
                                  //title:
                                  leading: Image.network(data['product-img']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['product-name'],
                                        style: GoogleFonts.roboto(
                                            color: Colors.amber,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        data['product-price'],
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey[200],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800], // Light grey shade
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: widget.onClose,
                ),
              ),
            ],
          ),
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
