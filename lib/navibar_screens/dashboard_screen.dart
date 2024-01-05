import 'package:fblogin/dasboard_screens/pcbuilder_screen.dart';
import 'package:fblogin/dasboard_screens/tutorials_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../reusable_widgets/custom_scaffold3.dart';
import '../dasboard_screens/community_screen.dart';
import '../dasboard_screens/marketplace_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold3(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 108, 25, 10),
          child: Column(
            children: [
              Text(
                'DASHBOARD: ',
                style: GoogleFonts.bebasNeue(fontSize: 52, color: Colors.amber,letterSpacing: 1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Take a tour looking at our very own '
                      '\n            personalised options',
                  style: TextStyle(fontSize: 23,fontFamily: 'RobotoCondensed', color: Colors.white,),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 15,crossAxisSpacing: 15),
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PcBuilderScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/icon1.png',
                              height: 130,
                              width: 130,
                            ),
                            SizedBox(height: 2,),
                            Text('PC BUILDER',style: TextStyle(fontSize: 24,fontFamily: 'RobotoCondensed',color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MarketPlaceScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/icon2.png',
                              height: 130,
                              width: 130,
                            ),
                            SizedBox(height: 1,),
                            Text('MARKETPLACE',style: TextStyle(fontSize: 24,fontFamily: 'RobotoCondensed',color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CommunityScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/icon3.png',
                              height: 130,
                              width: 130,
                            ),
                            SizedBox(height: 1,),
                            Text('COMMUNITY',style: TextStyle(fontSize: 24,fontFamily: 'RobotoCondensed',color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TutorialsScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/icon4.png',
                              height: 130,
                              width: 130,
                            ),
                            SizedBox(height: 1,),
                            Text('TUTORIALS',style: TextStyle(fontSize: 24,fontFamily: 'RobotoCondensed',color: Colors.white)),
                          ],
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
