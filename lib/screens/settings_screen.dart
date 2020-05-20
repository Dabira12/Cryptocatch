import 'package:cryptocatch/Widgets/about_app.dart';
import 'package:cryptocatch/screens/login_screen.dart';
import 'package:cryptocatch/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SettingsScreen extends StatefulWidget {
  static String id = "settings_screen";
  String email;
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = FirebaseAuth.instance;
  Future<String> getUser() async {
    final FirebaseUser user = await _auth.currentUser();
    widget.email = user.email;

    return user.email;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              print(snapshot.requireData);
            }
            return Container(
              child: Center(
                child: SpinKitRotatingPlain(
                  color: Colors.blue,
                  size: 100,
                ),
              ),
            );
          } else {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Hero(
                          tag: 'logo',
                          child: Container(
                            height: 200.0,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.email),
                            title: Text(
                              snapshot.data,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
//                        Card(
////                          child: ListTile(
////                            leading: Icon(Icons.lock),
////                            title: Text(
////                              "Change Password",
////                              style: TextStyle(fontSize: 20),
////                            ),
////                            trailing: Icon(Icons.arrow_forward_ios),
////                          ),
//                            ),
                        Card(
                          child: ListTile(
                            onTap: pushAboutApp,
                            leading: Icon(Icons.info),
                            title: Text(
                              "About App",
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Card(
                          color: Colors.amberAccent,
                          child: ListTile(
                            onTap: signout,
                            leading: Icon(Icons.highlight_off),
                            title: Text(
                              "Sign Out",
                              style: TextStyle(fontSize: 20),
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
        });
  }

  Future signout() async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, WelcomeScreen.id, (Route<dynamic> route) => false);
  }

  Future pushAboutApp() async {
    Navigator.pushNamed(context, about_app.id);
  }
}
