import 'package:flutter/material.dart';
import 'package:cryptocatch/services/HexColor.dart';
import 'package:google_fonts/google_fonts.dart';

class about_app extends StatelessWidget {
  static String id = "about_app";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About App"),
        backgroundColor: HexColor('#0D3AA9'),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset("images/logo.png"),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                " Crypyocatch was developed to be able to view information on numerous cryptocurrencies at a glance. \n \n Cryptocatch allows you to view your favorite cryptocurrency as well as the latest news articles on cryptocurrency",
                style: GoogleFonts.lato(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
