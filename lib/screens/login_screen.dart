import 'package:cryptocatch/screens/passwordReset_screen.dart';
import 'package:cryptocatch/screens/welcome_screen.dart';
import 'package:cryptocatch/Models/Coin.dart';
import 'package:cryptocatch/screens/page_selector.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../services/HexColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
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
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your password.',
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
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: HexColor("#347AF0"),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
//
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                PageSelector.id,
                                (Route<dynamic> route) => false);
                          }

                          setState(() {
                            showSpinner = false;
                          });
                        } catch (error) {
                          setState(() {
                            showSpinner = false;
                          });
                          switch (error.code) {
                            case "ERROR_INVALID_EMAIL":
                              errorMessage = "Invalid Email.";

                              break;
                            case "ERROR_WRONG_PASSWORD":
                              errorMessage = "Incorrect Password.";
                              break;
                            case "ERROR_USER_NOT_FOUND":
                              errorMessage =
                                  "User with this email doesn't exist.";
                              break;
                            case "ERROR_USER_DISABLED":
                              errorMessage =
                                  "User with this email has been disabled.";
                              break;
                            case "ERROR_TOO_MANY_REQUESTS":
                              errorMessage =
                                  "Too many requests. Try again later.";
                              break;
                            case "ERROR_OPERATION_NOT_ALLOWED":
                              errorMessage =
                                  "Signing in with Email and Password is not enabled.";
                              break;
                            default:
                              errorMessage = "An undefined Error happened.";
                          }
                          showShortToast(errorMessage);
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: launchPasswordReset,
                  child: Center(
                      child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 15),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void launchPasswordReset() {
    Navigator.pushNamed(context, PasswordResetScreen.id);
  }

  void showShortToast(String error) {
    Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.amberAccent,
        textColor: Colors.black,
        timeInSecForIosWeb: 3);
  }
}
