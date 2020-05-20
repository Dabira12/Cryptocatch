import 'package:cryptocatch/services/HexColor.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#347AF0"),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset("images/logo.png"),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "WELCOME TO ",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              TypewriterAnimatedTextKit(
                totalRepeatCount: 2,
                speed: Duration(milliseconds: 500),
                text: ['CryptoCatch'],
                textStyle: TextStyle(fontSize: 50, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  color: Colors.white,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  child: Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                      color: HexColor("#347AF0"),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 250,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  color: Colors.white,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                      color: HexColor("#347AF0"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
