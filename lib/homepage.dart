import 'package:final_mealsrecipe/view/favoritelist.dart';
import 'package:flutter/material.dart';
import 'package:final_mealsrecipe/view/desertlist.dart';
import 'package:final_mealsrecipe/view/seafoodlist.dart';
import 'package:final_mealsrecipe/app_config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Desertlist(),
    Seafoodlist(),
    FavoritePage()
  ];

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        key: Key('navbar'), 
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), title: Text('Desert', key: Key('choose_desert'),)),
          BottomNavigationBarItem(icon: Icon(Icons.free_breakfast, key: Key('icon_sea')), title: Text('Seafood', key: Key('choose_safood'))),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, key: Key('icon_fav')), title: Text('Favorite', key: Key('chooose_favorite'),))
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }

  _onItemTapped(int index){
    setState(() {
          _currentIndex = index;
        });
  }
}