
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/dasboard_screens/pc_builder/models/details.dart';
import 'package:flutter/material.dart';

class SearchDialog extends StatefulWidget {
  final String collectionName;
  final VoidCallback onClose;
  final Function(String) navigateToCollectionPage;
  final List<Map<String, dynamic>> products;
  final String appBarTitle;

  const SearchDialog({
    Key? key,
    required this.collectionName,
    required this.onClose,
    required this.navigateToCollectionPage,
    required this.products,
    required this.appBarTitle,
  }) : super(key: key);

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
            fit: BoxFit.cover,
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: "What are you searching for Today?",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                        .where(
                      "product-name",
                      isGreaterThanOrEqualTo: inputText,
                    )
                        .where(
                      "product-name",
                      isLessThan: inputText + 'z',
                    )
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
                        children: snapshot.data!.docs.map(
                              (DocumentSnapshot document) {
                            Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  border: Border.all(
                                    color: Colors.grey[800]!,
                                    width: 2.0,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetails(
                                          data,
                                          appBarTitle: widget.appBarTitle,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Image.network(data['product-img']),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['product-name'],
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data['product-price'].toString(),
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
                  color: Colors.grey[800],
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