import 'package:ems/constant/routing_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    Future.delayed(const Duration(seconds: 2), () {
      if (uid != null) {
        if (uid == "BFZEL3CJRoOf3mthtOR9sJaA4Dz1") {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutingConstant.adminHome, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutingConstant.bottombar, (route) => false);
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutingConstant.loginScreen, (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/png/dwella.png",
        ),
      ),
    );
  }
}
