import 'dart:async';
import 'dart:convert';

import 'package:final_mealsrecipe/database/dbhelper.dart';
import 'package:final_mealsrecipe/model/details.dart';
import 'package:final_mealsrecipe/model/favorite.dart';
import 'package:final_mealsrecipe/model/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IngredientsDetailPage extends StatefulWidget {
  final Ingredients ingredients;

  IngredientsDetailPage({Key key, @required this.ingredients})
      : super(key: key);
  @override
  _IngredientsDetailPageState createState() => _IngredientsDetailPageState();
}

class _IngredientsDetailPageState extends State<IngredientsDetailPage> {
  List<Detail> detail = [];
  Favorite favorite;
  List<Favorite> _records;
  Timer _everySecond;
  
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    Future<Null>.delayed(Duration.zero, () {
      key.currentState.showSnackBar(SnackBar(
        content: Text(widget.ingredients.strMeal),
      ));
    });

    super.initState();
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        DateTime.now().second.toString();
        fetchPost();
        check();
      });
    });
  }

  check(){
    _checkFav();
  }

  Future _checkFav() async {
    var db = DBHelper();
    var res = await db.checkFav(widget.ingredients.idMeal);

    setState(() {
     _records = res; 
    });
  }

  Future addRecord() async {
    var db = DBHelper();
    String statusFav = 'Favorite';

    var favorite = Favorite(
        widget.ingredients.idMeal,
        widget.ingredients.strMeal,
        widget.ingredients.strMealThumb,
        detail[0].strCategory,
        statusFav);

    await db.saveFav(favorite);
    print('saved');
  }

  void _saveData() {
    addRecord();
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
          title: Text('Detail Ingredients', key: Key('detail_page'),),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(
            key: Key('kembali'),
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
            // _records[0].statusFav == '' ?
            _records == null ? 
            IconButton(
              key: Key('favorited'),
              icon: Icon(Icons.favorite),
              color: Colors.black,
              onPressed: () {
                _saveData();
                key.currentState.showSnackBar(SnackBar(
        content: Text('Added to favorite', key: Key('response_fav'),),
      ));
              },
            ) 
            :
            IconButton(
              key: Key('unfavorited'),
              icon: Icon(Icons.favorite),
              color: Colors.red,
              onPressed: (){},
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
            tag: widget.ingredients.strMealThumb,
            child: Material(
              child: InkWell(
                child: Image.network(
                  '${widget.ingredients.strMealThumb}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            widget.ingredients.strMeal,
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
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.ingredients.idMeal}";
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
