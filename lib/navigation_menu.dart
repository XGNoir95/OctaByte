import 'package:fblogin/dasboard_screens/home_screen.dart';
import 'package:fblogin/dasboard_screens/profile_screen.dart';
import 'package:fblogin/navibar_screens/settings_screen.dart';
import 'package:fblogin/navibar_screens/trending_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:octabyte_main/navibar_screens/settings_screen.dart';
// import 'package:octabyte_main/navibar_screens/trending_screen.dart';
// import 'dashboard_screens/home_screen.dart';
// import 'dashboard_screens/profile_screen.dart';
// import 'navibar_screens/profile_screen.dart';
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
                  Text('Home',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed',fontSize: 17,letterSpacing: 1),
                  )],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),
                  Icon(Iconsax.flash, color: Colors.amber, size: 33),
                  Text('Trending',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed',fontSize: 16,letterSpacing: 1)),
                ],
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Column(
                children: [
                  SizedBox(height: 14,),
                  Icon(
                    Iconsax.setting_3,
                    color: Colors.amber,
                    size: 32,
                  ),
                  Text('Settings',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed',fontSize: 16.5,letterSpacing: 1)),
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
                  Text('Profile',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'RobotoCondensed',fontSize: 17,letterSpacing: 1)),
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
    TrendingScreen(),
    SettingsScreen(),
    ProfileScreen(),
  ];
}
