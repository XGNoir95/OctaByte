import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fblogin/reusable_widgets/custom_scaffold3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fblogin/reusable_widgets/custom_scaffold2.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../navigation_menu.dart';
import '../reusable_widgets/custom_scaffold.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(
      String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .get();
  }

  void _signOut(BuildContext context) async {
    await _auth.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signed Out Successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    // Reset to the dashboard screen when signing out
    final navigationController = Get.find<NavigationController>();
    navigationController.resetToDashboard();
  }

  void _editUser(BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _firstNameController =
            TextEditingController(text: userData['First Name']);
        final TextEditingController _lastNameController =
            TextEditingController(text: userData['Last Name']);
        final TextEditingController _userNameController =
            TextEditingController(text: userData['User Name']);

        return AlertDialog(
          title: Center(
            child: Text(
              'Edit User',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 30),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 31,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 31,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
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
                    content: Text(
                      'User data updated successfully!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {});
              },
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserData(
      String email, String firstName, String lastName, String userName) async {
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
    return CustomScaffold(
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

                    return FutureBuilder<
                        DocumentSnapshot<Map<String, dynamic>>>(
                      future: getUserDetails(currentUser!.email!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (snapshot.hasData && snapshot.data!.exists) {
                          Map<String, dynamic>? user = snapshot.data!.data();

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(
                                //   height: 85,
                                // ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [],
                                ),

                                SizedBox(
                                  height: 0,
                                ),
                                //Profile picture
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.grey[700]!,
                                      width: 2.0,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(25),
                                  child: const Icon(Icons.person,
                                      size: 80, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  user!['User Name'],
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: 53,
                                    color: Colors.amber,
                                    letterSpacing: 2,
                                    //fontFamily: 'RobotoCondensed',
                                  ),
                                ),
                                Text(currentUser.email!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'RobotoCondensed',
                                        fontSize: 20)),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            ' User Information:',
                                            style: GoogleFonts.bebasNeue(
                                              color: Colors.white,
                                              fontSize: 40,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(width: 80,),
                                             GestureDetector(child: Icon(Icons.settings_outlined, color: Colors.amber),onTap: () async {
                                              User? currentUser = _auth.currentUser;
                                              DocumentSnapshot<Map<String, dynamic>> snapshot =
                                              await getUserDetails(currentUser!.email!);
                                              Map<String, dynamic> userData = snapshot.data()!;
                                              _editUser(context, userData);
                                            },),

                                        ],
                                      ),
                                      SizedBox(height: 10,),


                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 50, // Adjust the height as needed
                                              margin: EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10),
                                                  Icon(Icons.first_page, color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'First Name: ',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.amber,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    user!['First Name'],
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            // Repeat the same pattern for other Container widgets
                                            Container(
                                              height: 50, // Adjust the height as needed
                                              margin: EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10),
                                                  Icon(Icons.info_outline, color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Last Name: ',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.amber,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    user!['Last Name'],
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            // Repeat the same pattern for other Container widgets
                                            Container(
                                              height: 50, // Adjust the height as needed
                                              margin: EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10),
                                                  Icon(Icons.android_outlined, color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'User Name: ',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.amber,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    user!['User Name'],
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                ],
                                              ),

                                            ),
                                            SizedBox(height: 5),
                                            // Repeat the same pattern for other Container widgets
                                            Container(
                                              height: 50, // Adjust the height as needed
                                              margin: EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10),
                                                  Icon(Icons.email_outlined, color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Email- ID: ',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.amber,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    user!['Email'],
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                      fontFamily: 'RobotoCondensed',
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              ],
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
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: 130,
                  ),
                  MaterialButton(
                    onPressed: () {
                      _signOut(context);
                    },
                    color: Colors.grey[900],
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.amber,size: 30),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Sign Out',
                            style: GoogleFonts.bebasNeue(
                                fontSize: 30,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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
