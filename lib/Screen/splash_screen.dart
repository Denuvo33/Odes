import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void init(context) async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 3));
    if (pref.getString('intro') == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/intro', (_) => false);
      return;
    } else {
      FirebaseAuth.instance.currentUser != null
          ? Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)
          : Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);

    return Scaffold(
      body: Center(
          child: FlutterLogo(
        size: 200,
      )),
    );
  }
}
