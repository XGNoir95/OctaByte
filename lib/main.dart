import 'package:fblogin/lottie.dart';
import 'package:fblogin/navibar_screens/notification/NotificationPage.dart';
import 'package:fblogin/navibar_screens/notification/firebase_api_noti.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkpoint-1',
      home: LottieAnimation(),
      navigatorKey: navigatorKey,
      routes: {
        '/notification_srceen': (context) => NotificationPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
