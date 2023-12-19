import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
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
          height: 75,
          backgroundColor: hexStringToColor('212121'),
          indicatorColor: Colors.white.withOpacity(0.1),

          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, color: Colors.amber, size: 32,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.build, color: Colors.amber , size: 32,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.store, color: Colors.amber, size: 32,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.group_add, color: Colors.amber, size: 32,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.video_collection, color: Colors.amber, size: 32,),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_2, color: Colors.amber, size: 32,),
              label: '',
            ),
          ],

        ),
      ),
      body: Obx(()=> controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [HomeScreen(),PcBuilderScreen(),MarketPlaceScreen(),CommunityScreen(),TutorialsScreen(),ProfileScreen(),];
}
