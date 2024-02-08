import 'package:fblogin/dasboard_screens/tutorials/tutorials_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dasboard_screens/marketplace/marketplace_screen.dart';
import '../dasboard_screens/pc_builder/pages/pcbuilder_screen.dart';
import '../reusable_widgets/custom_scaffold3.dart';
import 'package:fblogin/dasboard_screens/community/community_screen.dart';
import 'notification/notificationService.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late final LocalNotificationService service;

  @override
  void initState() {
    super.initState();
    service = LocalNotificationService();
    service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold3(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 108, 25, 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'DASHBOARD:',
                  style: GoogleFonts.bebasNeue(fontSize: 48, color: Colors.amber, letterSpacing: 1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Take a tour looking at our very own personalised options',
                      style: TextStyle(fontSize: 23, fontFamily: 'RobotoCondensed', color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PcBuilderScreen()));
                        if (service != null) {
                          await service.showNotificationWithPayload(
                            id: 0,
                            title: 'Welcome to OctaBuilder',
                            body: 'Explore our wide range of components',
                            payload: '',
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 12),
                              Image.asset(
                                'assets/icons/pc.png',
                                height: 110,
                                width: 110,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 2),
                              Text('PC BUILDER', style: TextStyle(fontSize: 24, fontFamily: 'RobotoCondensed', color: Colors.amber)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MarketPlaceScreen()));
                        if (service != null) {
                          await service.showNotificationWithPayload(
                            id: 0,
                            title: 'Welcome to Octane',
                            body: 'Have a look at our user-friendly market',
                            payload: '',
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Image.asset(
                                'assets/icons/market.png',
                                height: 110,
                                width: 110,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 4),
                              Text('MARKETPLACE', style: TextStyle(fontSize: 24, fontFamily: 'RobotoCondensed', color: Colors.amber)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()));
                        if (service != null) {
                          await service.showNotificationWithPayload(
                            id: 0,
                            title: 'Welcome to Octagram',
                            body: 'Explore our community',
                            payload: '',
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 12),
                              Image.asset(
                                'assets/icons/comm.png',
                                height: 110,
                                width: 110,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 1),
                              Text('COMMUNITY', style: TextStyle(fontSize: 24, fontFamily: 'RobotoCondensed', color: Colors.amber)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialsPage()));
                        if (service != null) {
                          await service.showNotificationWithPayload(
                            id: 0,
                            title: 'Welcome to Octahub',
                            body: 'Learn about the absolute basicsc from scratch!',
                            payload: '',
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 12),
                              Image.asset(
                                'assets/icons/tuto1.png',
                                height: 110,
                                width: 110,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 1),
                              Text('TUTORIALS', style: TextStyle(fontSize: 24, fontFamily: 'RobotoCondensed', color: Colors.amber)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
