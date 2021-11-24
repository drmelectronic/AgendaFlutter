import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashState createState()  => _SplashState();

}

class _SplashState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    loadBackground();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x660066a9),
                          Color(0x990066a9),
                          Color(0xcc0066a9),
                          Color(0xff0066a9),
                        ]
                    )
                ),
                child: Image.asset('assets/images/logo.png', width: 560)
            )
        )
    );
  }

  void loadBackground() async {
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
    
  }

}