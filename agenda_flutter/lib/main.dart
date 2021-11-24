import 'package:agenda_flutter/screens/agenda_screen.dart';
import 'package:agenda_flutter/screens/login_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda TCONTUR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      home: AnimatedSplashScreen.withScreenFunction(
        pageTransitionType: PageTransitionType.fade,
          splashTransition: SplashTransition.fadeTransition,
          splash: 'assets/images/icon.png',
          // backgroundColor: Colors.blue,
          screenFunction: () => loadDatabase()),
    );
  }

  Future<Widget> loadDatabase() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    if (token == null || token == '') {
      prefs.setString('source', 'server');
      return const LoginScreen();
    } else {
      prefs.setString('source', 'db');
      return AgendaScreen();
    }
  }
}
