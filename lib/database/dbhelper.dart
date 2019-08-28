import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:final_mealsrecipe/model/favorite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await setDB();

    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, 'mealsDB');

    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);

    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE favorite(id INTEGER PRIMARY KEY, idMeal TEXT, strMeal TEXT, strMealThumb TEXT, categoryMeals TEXT, statusFav TEXT)');

    print('DB Created');
  }

  Future<int> saveFav(Favorite favorite) async {
    var dbClient = await db;

    int res = await dbClient.insert('favorite', favorite.toMap());

    print('Data Inserted');
    return res;
  }

  Future<List<Favorite>> getFav(String params) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM favorite WHERE categoryMeals=?', [params]);
    List<Favorite> favoritedata = new List();

    for (int i = 0; i < list.length; i++) {
      var favorite = Favorite(
          list[i]['idMeal'],
          list[i]['strMeal'],
          list[i]['strMealThumb'],
          list[i]['categoryMeals'],
          list[i]['statusFav']);
      favorite.setFavoriteId(list[i]['id']);
      favoritedata.add(favorite);
    }
    return favoritedata;
  }

  Future<List<Favorite>> checkFav(String params) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM favorite WHERE idMeal=?', [params]);


    // if (list.length > 0) {
      List<Favorite> favoritedata = new List();
      for (int i = 0; i < list.length; i++) {
        var favorite = Favorite(
            list[i]['idMeal'],
            list[i]['strMeal'],
            list[i]['strMealThumb'],
            list[i]['categoryMeals'],
            list[i]['statusFav']);
        favorite.setFavoriteId(list[i]['id']);
        favoritedata.add(favorite);
      }
      
      if(favoritedata.length > 0){
        return favoritedata;
      }else{
        return null;
      }
    // } else {
    //   return null;
    // }
  }

  Future<int> countFav(String params) async {
    var dbClient = await db;
    // int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM favorite where idMeal?=', [params]));
    int res = (await dbClient.rawQuery(
        'SELECT COUNT(*) FROM favorite where idMeal?=', [params])) as int;
    return res;
  }

  Future<bool> updateFav(Favorite favorite) async {
    var dbClient = await db;
    int res = await dbClient.update('favorite', favorite.toMap(),
        where: 'id=?', whereArgs: <int>[favorite.id]);

    return res > 0 ? true : false;
  }

  Future<int> deleteFav(Favorite favorite) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM favorite WHERE id = ?', [favorite.id]);
    return res;
  }
}
