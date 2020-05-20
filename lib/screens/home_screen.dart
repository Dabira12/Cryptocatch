import 'dart:convert';

import 'package:cryptocatch/services/HexColor.dart';
import 'package:cryptocatch/Widgets/favourite_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cryptocatch/Models/Coin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool liked = false;
  String uid;
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  Future getLikedCoins() async {
    List<dynamic> array = [];
    final FirebaseUser user = await _auth.currentUser();
    uid = user.uid;

    CollectionReference usersRef = _db.collection("Users");
    await usersRef.document(uid).get().then((DocumentSnapshot ds) {
      array = ds.data["liked_coins"];
      print(array);
    });
    return array;
  }

  Future getCoinData() async {
    List<Coin> coins = [];

    http.Response response = await http.get(
        'https://api.coincap.io/v2/assets?limit=75'); //capped at 300 for some reason

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      //print(jsonData);

      for (var data in jsonData) {
        String color;
        if (double.parse(data["changePercent24Hr"]) > 0) {
          color = "#008000";
        } else {
          color = "#FF0000";
        }
        Coin coin = Coin(
            data["name"],
            (double.tryParse(data["priceUsd"])).toStringAsFixed(2),
            (double.tryParse(data["changePercent24Hr"])).toStringAsFixed(2),
            color,
            data["id"]);
        coins.add(coin);
      }
      return coins;
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
              future: Future.wait(
                [getCoinData(), getLikedCoins()],
              ),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                  return ListView.builder(
                    itemCount: snapshot.data[0].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Image.asset(
                            'images/COINS/' +
                                (snapshot.data[0][index].id).toLowerCase() +
                                '.png',
                            height: 35,
                            width: 35,
                          ),
                          title: Text(snapshot.data[0][index].name),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "\$" + snapshot.data[0][index].priceUsd,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 40),
                                Text(
                                    "%" +
                                        snapshot
                                            .data[0][index].changePercent24Hr,
                                    style: TextStyle(
                                        color: HexColor(
                                            snapshot.data[0][index].color))),
                              ]),
                          trailing: Column(
                            children: <Widget>[
                              FavouriteButton(
                                coin: snapshot.data[0][index],
                                liked_coins: snapshot.data[1],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}
