import 'package:cryptocatch/Models/Coin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteButton extends StatefulWidget {
  final Coin coin;
  final List liked_coins;
  bool liked = false;

  FavouriteButton({Key key, this.coin, this.liked_coins}) : super(key: key);
  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  static List<String> favourite_list = new List();
  String uid;
  bool liked = false;
  bool tester = false;

  @override
  void initState() {
    super.initState();
    getLiked();
  }

  void inputData() async {
    List<dynamic> array = [];
    bool isThere = false;

    final FirebaseUser user = await _auth.currentUser();
    uid = user.uid;
    CollectionReference usersRef = _db.collection("Users");

    await usersRef.document(uid).get().then((DocumentSnapshot ds) {
      array = ds.data["liked_coins"];
      for (String coin in array) {
        if (widget.coin.id == coin) {
          _db.collection("Users").document(uid).updateData({
            "liked_coins": FieldValue.arrayRemove([widget.coin.id])
          });
          isThere = true;
        }
      }
    });

    if (!isThere) {
      usersRef.document(uid).updateData({
        "liked_coins": FieldValue.arrayUnion([widget.coin.id])
      });
    }

    return;
  }

  bool getLiked() {
    if (widget.liked_coins.isEmpty) {
      widget.liked = false;
      return false;
    }

    for (String element in widget.liked_coins) {
      if (widget.coin.id == element) {
        widget.liked = true;
        return true;
      }
    }
    widget.liked = false;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          widget.liked ? Icons.star : Icons.star_border,
          color: widget.liked ? Colors.orange : Colors.black,
        ),
        iconSize: 25,
        color: Colors.white,
        onPressed: () {
          inputData();
          setState(() {
            widget.liked = !widget.liked;
          });
        },
      ),
    );
  }
}
