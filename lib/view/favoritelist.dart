import 'package:final_mealsrecipe/database/dbhelper.dart';
import 'package:final_mealsrecipe/model/favorite.dart';
import 'package:final_mealsrecipe/view/detailfav.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Choice _selectedChoice = choices[0];
  Color _iconColor1, _iconColor2 = Colors.white;
  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Page', key: Key('favorite_page'),),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          IconButton(
            key: Key('icon_desert'),
            icon: Icon(choices[0].icon),
            color: _iconColor1,
            onPressed: () {
              _select(choices[0]);
              setState(() {
               _iconColor1 = Colors.grey;
               _iconColor2 = Colors.white;  
              });
            },
          ),
          IconButton(
            key: Key('icon_seafood'),
            icon: Icon(choices[1].icon),
            color: _iconColor2,
            onPressed: () {
              _select(choices[1]);
              setState(() {
               _iconColor1 = Colors.white; 
               _iconColor2 = Colors.grey; 
              });
            },
          )
        ],
      ),
      body: ChoiceCard(choice: _selectedChoice),
    );
  }
}

class Choice {
  Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

List<Choice> choices = <Choice>[
  Choice(title: 'Desert', icon: Icons.fastfood),
  Choice(title: 'Seafood', icon: Icons.free_breakfast)
];

class ChoiceCard extends StatefulWidget {
  final Choice choice;
  final List<Favorite> favoritedata;

  ChoiceCard({Key key, this.choice, this.favoritedata}) : super(key: key);

  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBodyFav(),
    );
  }

  getBodyFav() {
    if (widget.choice.title == 'Desert') {
      return _getDesert();
    } else if(widget.choice.title == 'Seafood') {
      return _getSeafood();
    }
  }

  _getDesert() {
    return FutureBuilder(
      future: db.getFav('Dessert'),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        var data = snapshot.data;
        return snapshot.hasData
            ? getGridDesert(data)
            : Center(child: Text('No data'));
      },
    );
  }

  GridView getGridDesert(data) => GridView.builder(
        itemCount: data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int position) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                children: <Widget>[ 
                  Hero(
                    tag: data[position].strMealThumb,
                    child: Material(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IngredientsFavoritePage(
                                            favoritedata: data[position])));
                            final snackBar = SnackBar(
                              content: Text(data[position].strMeal),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          },
                          child: Image.network(data[position].strMealThumb,
                              height: 110.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(data[position].strMeal,
                      softWrap: true, style: TextStyle(fontSize: 10.0))
                ],
              ),
            ),
          );
        },
      );

  _getSeafood() {
    return FutureBuilder(
      future: db.getFav('Seafood'),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        var data = snapshot.data;
        return snapshot.hasData
            ? getGridSeafood(data)
            : Center(child: Text('No data'));
      },
    );
  }

  GridView getGridSeafood(data) => GridView.builder(
        itemCount: data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int position) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: data[position].strMealThumb,
                    child: Material(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IngredientsFavoritePage(
                                            favoritedata: data[position])));
                            final snackBar = SnackBar(
                              content: Text(data[position].strMeal),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          },
                          child: Image.network(data[position].strMealThumb,
                              height: 110.0, key: Key('gridfav_seafood'))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(data[position].strMeal,
                      softWrap: true, style: TextStyle(fontSize: 10.0))
                ],
              ),
            ),
          );
        },
      );
}