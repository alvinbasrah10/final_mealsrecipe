import 'dart:async';
import 'package:final_mealsrecipe/view/detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_mealsrecipe/model/ingredients.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Ingredients> ingredients = [];
  String txtSearch;
  Timer timeHandle;
  TextEditingController searchController = TextEditingController();
  bool notValue;
  final focus = new FocusNode();

  void getText() {
    setState(() {
      textChanged();
    });
  }

  textChanged() async {
    // if (timeHandle != null){
    //   timeHandle.cancel();
    // }
    // timeHandle = Timer(Duration(seconds: 0), () async {
    String dataURL =
        "https://www.themealdb.com/api/json/v1/1/search.php?s=${searchController.text}";
    http.Response response = await http.get(dataURL);
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200 && responseJson['meals'] != null) {
      ingredients = (responseJson['meals'] as List)
          .map((p) => Ingredients.fromJson(p))
          .toList();

      setState(() {
        notValue = false;
      });
    } else {
      setState(() {
        notValue = true;
      });
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Search Page',
              key: Key('head_search'),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
            TextField(
                focusNode: focus,
                key: Key('text_search'),
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a keyword',
                )),
          ],
        ),
        leading: IconButton(
          key: Key('back_fromsearch'),
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: getBodySearch(),
      floatingActionButton: FloatingActionButton(
          key: Key('float_search'),
          onPressed: () {
            getText();
            FocusScope.of(context).requestFocus(focus);
          },
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
          backgroundColor: Colors.lightGreen),
    );
  }

  getBodySearch() {
    if (ingredients.length == 0) {
      return Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 250.0),
            ),
            searchController.text == ''
                ? Text('Search Meals', key: Key('search_meals'))
                : CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      if (notValue == true) {
        return Center(
            child: Text(
          'data not found',
          key: Key('notfound'),
        ));
      } else {
        return getListSearch();
      }
    }
  }

  ListView getListSearch() => ListView.builder(
        itemCount: ingredients.length,
        key: Key('list_search'),
        itemBuilder: (BuildContext context, int position) {
          return getSearch(position);
        },
      );

  Widget getSearch(int i) {
    return Container(
      child: Card(
        child: Column(
          children: <Widget>[
            Hero(
                tag: ingredients[i].strMealThumb,
                child: Material(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IngredientsDetailPage(
                                ingredients: ingredients[i])));
                  },
                  child: Row(
                    children: <Widget>[
                      Image.network('${ingredients[i].strMealThumb}',
                          height: 120.0),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                      ),
                      Text(
                        ingredients[i].strMeal,
                        key: Key('txtListSearch'),
                      )
                    ],
                  ),
                )))
          ],
        ),
      ),
    );
  }
}
