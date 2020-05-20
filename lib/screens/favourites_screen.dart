import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cryptocatch/Models/Coin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cryptocatch/services/HexColor.dart';
import 'package:cryptocatch/Widgets/favourite_button.dart';

class FavouritesScreen extends StatefulWidget {
  static String id = "FavouritesScreen";
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
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
//      print(array);
    });
    return array;
  }

  Future getCoinData() async {
    List<Coin> coins = [];
    Map<String, List> map = {};

    List liked_coins = await getLikedCoins();
    print(liked_coins);
    if (liked_coins.isEmpty) {
      liked_coins = [];
      map["liked_coins"] = liked_coins;
    } else {
      map["liked_coins"] = liked_coins;
      for (String liked_coin in liked_coins) {
        http.Response response = await http.get(
            'https://api.coincap.io/v2/assets/$liked_coin'); //capped at 300 for some reason

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body)['data'];
          //print(jsonData);

          String color;
          if (double.parse(jsonData["changePercent24Hr"]) > 0) {
            color = "#008000";
          } else {
            color = "#FF0000";
          }
          Coin coin = Coin(
              jsonData["name"],
              (double.tryParse(jsonData["priceUsd"])).toStringAsFixed(2),
              (double.tryParse(jsonData["changePercent24Hr"]))
                  .toStringAsFixed(2),
              color,
              jsonData["id"]);
          coins.add(coin);
        } else {
          print(response.statusCode);
        }
      }
      map["coins"] = coins;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: getCoinData(),
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
                if (snapshot.data["liked_coins"].isEmpty) {
                  return Center(
                    child: (Text(
                      "You have no favourite coins.\nReturn to the home screen and favourite any coin(s)\nto view it here",
                      style: TextStyle(fontSize: 25),
                    )),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data["coins"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Image.asset(
                            'images/COINS/' +
                                (snapshot.data["coins"][index].id)
                                    .toLowerCase() +
                                '.png',
                            height: 35,
                            width: 35,
                          ),
                          title: Text(snapshot.data["coins"][index].name),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "\$" + snapshot.data["coins"][index].priceUsd,
                                ),
                                SizedBox(width: 40),
                                Text(
                                    "%" +
                                        snapshot.data["coins"][index]
                                            .changePercent24Hr,
                                    style: TextStyle(
                                        color: HexColor(snapshot
                                            .data["coins"][index].color))),
                              ]),
                          trailing: Column(
                            children: <Widget>[
                              FavouriteButton(
                                coin: snapshot.data["coins"][index],
                                liked_coins: snapshot.data["liked_coins"],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            }),
      ),
    );
  }
}
