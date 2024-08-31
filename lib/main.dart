import 'package:flutter/material.dart';
import 'screens/login_screen_rev.dart';
import 'screens/dashboard_screen.dart';
// import 'package:login_portal/screens/sibling_information_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parent Portal',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        // '/siblings': (context) => SiblingInformationScreen(
        //   siblings: ModalRoute.of(context)!.settings.arguments as List<dynamic>,
        // ),
      },
    );
  }
}
