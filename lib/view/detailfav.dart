import 'dart:async';
import 'dart:convert';

import 'package:final_mealsrecipe/database/dbhelper.dart';
import 'package:final_mealsrecipe/model/details.dart';
import 'package:final_mealsrecipe/model/favorite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IngredientsFavoritePage extends StatefulWidget {
  final Favorite favoritedata;

  const IngredientsFavoritePage({Key key, @required this.favoritedata})
      : super(key: key);
  @override
  _IngredientsFavoritePageState createState() =>
      _IngredientsFavoritePageState();
}

class _IngredientsFavoritePageState extends State<IngredientsFavoritePage> {
  List<Detail> detail = [];
  Timer _everySecond;

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    Future<Null>.delayed(Duration.zero, () {
      key.currentState.showSnackBar(SnackBar(
        content: Text(widget.favoritedata.strMeal),
      ));
    });

    super.initState();
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        DateTime.now().second.toString();
        fetchPost();
      });
    });
  }

  void delete(Favorite favorite) {
    var db = DBHelper();
    db.deleteFav(favorite);
  }

  void _deleteData() {
    AlertDialog alertDialog = AlertDialog(
      content: Text('Hapus favorite ?',
          key: Key('dialog_delete)'), style: TextStyle(fontSize: 20.0)),
      actions: <Widget>[
        RaisedButton(
          key: Key('btn_delete'),
          child: Text(
            'Delete', key: Key('tombol_delete'),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
            delete(widget.favoritedata);
            Navigator.pop(context);       
          },
        ),
        RaisedButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: key,
        appBar: AppBar(
          title: Text(
            'Detail Favorite Ingredients',
            key: Key('appbardetail_fav'),
          ),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(
            key: Key('back_fromfav'),
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
            IconButton(
              key: Key('delete'),
              icon: Icon(Icons.favorite),
              color: Colors.red,
              onPressed: () {
                _deleteData();
              },
            )
          ],
        ),
        body: getBodyDetail(),
      ),
    );
  }

  getBodyDetail() {
    if (detail.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return getListView();
    }
  }

  getListView() {
    return ListView(
      children: <Widget>[
        Container(
          width: 240,
          height: 240,
          child: Hero(
            tag: widget.favoritedata.strMealThumb,
            child: Material(
              child: InkWell(
                child: Image.network(
                  '${widget.favoritedata.strMealThumb}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            widget.favoritedata.strMeal,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Category :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              detail[0].strCategory,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Tags :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            detail[0].strTags == null
                ? Text(' - ')
                : Text(
                    detail[0].strTags,
                    style: TextStyle(fontSize: 16),
                  )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Drink Alternate :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            detail[0].strDrinkAlternate == null
                ? Text(' - ')
                : Text(
                    detail[0].strDrinkAlternate,
                    style: TextStyle(fontSize: 16),
                  )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Origin :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            detail[0].strArea == null
                ? Text(' - ')
                : Text(
                    detail[0].strArea,
                    style: TextStyle(fontSize: 16),
                  )
          ],
        ),
        Container(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Instructions :',
            style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.all(4.0),
          child: Text(detail[0].strInstructions,
              textAlign: TextAlign.justify, style: TextStyle(fontSize: 14)),
        )
      ],
    );
  }

  fetchPost() async {
    String dataURL =
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.favoritedata.idMeal}";
    http.Response response = await http.get(dataURL);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      detail = (responseJson['meals'] as List)
          .map((p) => Detail.fromJson(p))
          .toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
