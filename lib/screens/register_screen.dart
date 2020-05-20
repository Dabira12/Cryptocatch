import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'page_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptocatch/screens/welcome_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "RegistrationScreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _db = Firestore.instance;
  String doc_id;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String uid;
  String errorMessage;

  void inputData() async {
    final FirebaseUser user = await _auth.currentUser();

    uid = user.uid;

    _db
        .collection("Users")
        .document(uid)
        .setData({"liked_coins": [], "uid": uid});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 100),
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
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
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
                    password = value; //captures user password
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
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
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      //Register button
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                PageSelector.id,
                                (Route<dynamic> route) => false);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                          inputData();
                        } catch (error) {
                          print(error.code);
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
                            case "ERROR_WEAK_PASSWORD":
                              errorMessage =
                                  "Password must be at least 6 characters";
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
                        'Register',
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
