import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(Duration(seconds: 4), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Image.asset(
                'image/StockCheck APP .png',
                width: 300,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Uni",
                style: GoogleFonts.urbanist(
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              ScaleTransition(
                scale: animation,
                child: Image.asset(
                  'image/s.png',
                  width: 50,
                ),
              ),
              Text(
                "tock",
                style: GoogleFonts.urbanist(
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
