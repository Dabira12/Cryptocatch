import 'package:flutter/material.dart';
import 'package:cryptocatch/services/HexColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordResetScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  static String id = "passwordReset_screen";
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blue),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 250,
                  width: 200,
                  child: Image.asset(
                    'images/confused.png',
                    height: 250,
                    width: 200,
                  ),
                ),
                Center(
                  child: Text("Forgot your Password?",
                      style: TextStyle(color: Colors.black, fontSize: 30)),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                      "We've all been there, enter your email to reset your password...",
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
                SizedBox(height: 12.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor("#347AF0"), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor("#347AF0"), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: HexColor("#347AF0"),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          await _auth.sendPasswordResetEmail(email: email);

                          print("done");
                        } catch (e) {
                          print(e);
                        }

                        showShortToast(email);
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showShortToast(String email) {
    Fluttertoast.showToast(
        msg: "A password reset link has been sent to " + email,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.amberAccent,
        textColor: Colors.black,
        timeInSecForIosWeb: 3);
  }
}
