import 'package:cryptocatch/Models/Coin.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favourites_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cryptocatch/services/HexColor.dart';
import 'news_screen.dart';
import 'settings_screen.dart';

class PageSelector extends StatefulWidget {
  static String id = "PageController";
  final String email;
  PageSelector({Key key, @required this.email}) : super(key: key);
  @override
  _PageSelectorState createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  int _selectedPage = 0;
  final _pageOption = [
    HomeScreen(),
    FavouritesScreen(),
    NewsScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOption[_selectedPage],
      bottomNavigationBar: CurvedNavigationBar(
//        color: HexColor('#4d88ff'),
        color: HexColor('#0D3AA9'),
        backgroundColor: Colors.white,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.star, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          print('current index is $index');
          setState(() {
            _selectedPage = index;
          });
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
