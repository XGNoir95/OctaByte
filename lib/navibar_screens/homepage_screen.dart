import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fblogin/reusable_widgets/custom_scaffold2.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(String email) async {
    return await FirebaseFirestore.instance.collection('users').doc(email).get();
  }

  void _signOut(BuildContext context) async {
    await _auth.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signed Out Successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editUser(BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _firstNameController = TextEditingController(text: userData['First Name']);
        final TextEditingController _lastNameController = TextEditingController(text: userData['Last Name']);
        final TextEditingController _userNameController = TextEditingController(text: userData['User Name']);

        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'User Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                User? currentUser = _auth.currentUser;
                await updateUserData(
                  currentUser!.email!,
                  _firstNameController.text,
                  _lastNameController.text,
                  _userNameController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User data updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserData(String email, String firstName, String lastName, String userName) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'First Name': firstName,
        'Last Name': lastName,
        'User Name': userName,
      });
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold2(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<User?>(
                stream: _auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
        
                  if (snapshot.hasData && snapshot.data != null) {
                    User? currentUser = snapshot.data;
        
                    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: getUserDetails(currentUser!.email!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (snapshot.hasData && snapshot.data!.exists) {
                          Map<String, dynamic>? user = snapshot.data!.data();
        
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 80,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Welcome Back ',
                                        style: TextStyle(
                                          fontSize: 37,
                                          color: Colors.amber,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                      Text(
                                        user!['User Name'],
                                        style: TextStyle(
                                          fontSize: 37,
                                          color: Colors.white,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25,),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.all(25),
                                    child: const Icon(Icons.person, size: 80,color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Your Details:  ',
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                      fontFamily: 'RobotoCondensed',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'First Name: ',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.amber,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Text(
                                        user!['First Name'],
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Last Name: ',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.amber,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Text(
                                        user!['Last Name'],
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'User Name: ',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.amber,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Text(
                                        user!['User Name'],
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Email: ',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.amber,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Text(
                                        user!['Email'],
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontFamily: 'RobotoCondensed',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Text("No data");
                        }
                      },
                    );
                  } else {
                    return Text("User not signed in");
                  }
                },
              ),
              SizedBox(height: 23),
              Row(
                children: [
                  SizedBox(width: 30,),
                  MaterialButton(
                    onPressed: () async {
                      User? currentUser = _auth.currentUser;
                      DocumentSnapshot<Map<String, dynamic>> snapshot = await getUserDetails(currentUser!.email!);
                      Map<String, dynamic> userData = snapshot.data()!;
                      _editUser(context, userData);
                    },
                    color: Colors.grey[900],
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined,color: Colors.amber,),
                        SizedBox(width: 10,),
                        Text('Edit',
                            style: TextStyle(fontSize: 22,color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(width: 100,),
                  MaterialButton(
                    onPressed: () {
                      _signOut(context);
                    },
                    color: Colors.grey[900],
                    child: Row(
                      children: [
                        Icon(Icons.logout,color: Colors.amber,),
                        SizedBox(width: 10,),
                        Text('Sign Out',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
