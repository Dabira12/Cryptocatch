import 'package:cryptocatch/screens/settings_screen.dart';
import 'package:cryptocatch/Models/Coin.dart';
import 'package:cryptocatch/screens/favourites_screen.dart';
import 'package:cryptocatch/screens/home_screen.dart';
import 'package:cryptocatch/screens/login_screen.dart';
import 'package:cryptocatch/screens/welcome_screen.dart';
import 'package:cryptocatch/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'screens/page_selector.dart';
import 'screens/passwordReset_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cryptocatch/Widgets/about_app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        about_app.id: (context) => about_app(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        PageSelector.id: (context) => PageSelector(),
        PasswordResetScreen.id: (context) => PasswordResetScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
      },
    );
  }
}
