import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax/iconsax.dart';

// import 'package:octa_byte/dashboard_screens/community_screen.dart';
// import 'package:octa_byte/dashboard_screens/home_screen.dart';
// import 'package:octa_byte/dashboard_screens/pcbuilder_screen.dart';
// import 'package:octa_byte/dashboard_screens/profile_screen.dart';
// import 'package:octa_byte/dashboard_screens/marketplace_screen.dart';
// import 'package:octa_byte/dashboard_screens/tutorials_screen.dart';
// import 'package:octa_byte/utils/color_utils.dart';
import 'dashboard_screens/community_screen.dart';
import 'dashboard_screens/home_screen.dart';
import 'dashboard_screens/marketplace_screen.dart';
import 'dashboard_screens/pcbuilder_screen.dart';
import 'dashboard_screens/profile_screen.dart';
import 'dashboard_screens/tutorials_screen.dart';
import 'utils/color_utils.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 70,
          backgroundColor: hexStringToColor('212121'),
          indicatorColor: Colors.white.withOpacity(0.1),
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
          controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),
                  Icon(
                    Iconsax.home_1,
                    color: Colors.amber,
                    size: 32,
                  ),
                  Text('Home',style: TextStyle(color: Colors.white,fontFamily: 'RobotoCondensed',fontSize: 17,),
                  )],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),
                  Icon(Iconsax.cpu, color: Colors.amber, size: 33),
                  Text('Pc-Build',style: TextStyle(color: Colors.white,fontFamily: 'RobotoCondensed',fontSize: 16)),
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),
                  Icon(
                    Iconsax.shopping_cart,
                    color: Colors.amber,
                    size: 32,
                  ),
                  Text('Market',style: TextStyle(color: Colors.white,fontFamily: 'RobotoCondensed',fontSize: 16.5)),
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),
                  Icon(
                    Icons.group_add_outlined,
                    color: Colors.amber,
                    size: 32,
                  ),
                  Text('Groups',style: TextStyle(color: Colors.white,fontFamily: 'RobotoCondensed',fontSize: 17)),
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),
                  Icon(
                    Iconsax.video_octagon,
                    color: Colors.amber,
                    size: 32,
                  ),
                  Text('Tutorial',style: TextStyle(color: Colors.white,fontFamily: 'RobotoCondensed',fontSize: 17)),
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),

                  Icon(
                    Iconsax.security_user,
                    color: Colors.amber,
                    size: 32,
                  ),
                  Text('Profile',style: TextStyle(color: Colors.white,fontFamily: 'RobotoCondensed',fontSize: 17)),
                ],
              ),
              label: '',

            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    PcBuilderScreen(),
    MarketPlaceScreen(),
    CommunityScreen(),
    TutorialsScreen(),
    ProfileScreen(),
  ];
}