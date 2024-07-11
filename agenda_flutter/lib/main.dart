import 'package:agenda/screens/agenda_screen.dart';
import 'package:agenda/screens/login_screen.dart';
import 'package:agenda/services/api_service.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entity/empresa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    var apiService = APIService();
    List<Empresa> empresas = (await apiService.loadEmpresas());
    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    SharedPreferences prefs = await prefs0;
    String? token = prefs.getString('token');
    if (token == null || token == '') {
      prefs.setString('source', 'server');
      return LoginScreen(empresas: empresas);
    } else {
      prefs.setString('source', 'db');
      return AgendaScreen(empresas: empresas);
    }
  }
}
