import 'package:flutter/material.dart';
import 'package:fblogin/reusable_widgets/custom_scaffold3.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notificationService.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key,  required this.payload}) : super(key: key);
  final String payload;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final LocalNotificationService service;

  void initState() {
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text(
          'Notifications',
          style: GoogleFonts.bebasNeue(color: Colors.amber, fontSize: 40),
        ),
        centerTitle: true,
        actions: [
          // Sidebar icon to open the drawer
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      // Use the Drawer widget for the sidebar
      endDrawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                ),
                child: Center(
                  child: Text(
                    'Sidebar',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              // ListTile(
              //   leading: Icon(Icons.settings, color: Colors.white),
              //   title: Text('Settings', style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     // Handle settings item tap
              //     Navigator.pop(context); // Close the drawer
              //     // Add your logic for settings screen navigation if needed
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.white),
                title: Text('Notifications', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  await service.showNotificationWithPayload(
                    id: 0,
                    title: 'Welcome',
                    body: 'Lets build PC.',
                    payload:
                    'Hey Explore the latest and new products. ',
                  );
                  // Handle notifications item tap
                  Navigator.pop(context); // Close the drawer
                  // Add your logic for notifications screen navigation if needed
                },
                // Add more ListTile items as needed
              ),
            ],
          ),
        ),
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
          Center(
            child: Text(
              widget.payload,
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => SettingsScreen (payload: payload))));
    }
  }
}
