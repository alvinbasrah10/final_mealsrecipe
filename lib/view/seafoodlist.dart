import 'package:flutter/material.dart';
import 'package:final_mealsrecipe/model/ingredients.dart';
import 'package:final_mealsrecipe/view/detail.dart';
import 'package:final_mealsrecipe/view/search.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Seafoodlist extends StatefulWidget {
  Seafoodlist({Key key}) : super(key: key);

  @override
  _SeafoodlistState createState() => _SeafoodlistState();
}

class _SeafoodlistState extends State<Seafoodlist> {
  List<Ingredients> ingredients = [];
  
  @override
  void initState(){
    super.initState();
    
  loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seafood List', key: Key('seafood_list'),),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          IconButton(
            key: Key('search_icon'),
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPage()));
            },
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody(){
    if (ingredients.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return getGridView();
    }
  }

  GridView getGridView() => GridView.builder(
    itemCount: ingredients.length,
    itemBuilder: (BuildContext context, int position){
      return getRow(context, position);  
    },
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  );

  Widget getRow(context, int i){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Hero(
              tag: ingredients[i].strMealThumb,
              child: Material(
                child: InkWell(
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) => IngredientsDetailPage(ingredients: ingredients[i])
                   )
                   );
                   final snackBar = SnackBar(
                     content: Text(ingredients[i].strMeal),
                   ); 
                   Scaffold.of(context).showSnackBar(snackBar);
                  },
                  child: Image.network('${ingredients[i].strMealThumb}', height: 120.0, key: Key('gridview_seafood'),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Text(ingredients[i].strMeal,
            softWrap: true,
            style: TextStyle(fontSize: 10.0))
          ],
        ),
      ),
    );
  }
  loadData() async {

    String dataURL =
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood";
    http.Response response = await http.get(dataURL);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {    
          setState(() {
        ingredients = (responseJson['meals'] as List)
            .map((p) => Ingredients.fromJson(p))
            .toList();
      });
    } else {
      throw Exception('Failed to load photos');
    }
  } 
}