class Favorite{
  int id;
  String _idMeal;
  String _strMeal;
  String _strMealThumb;
  String _categoryMeals;
  String _statusFav;
   
  Favorite(this._idMeal, this._strMeal, this._strMealThumb, this._categoryMeals,this._statusFav);
  Favorite.map(dynamic obj){
    this._idMeal = obj['idMeal'];
    this._strMeal = obj['strMeal'];
    this._strMealThumb = obj['strMealThumb'];
    this._categoryMeals = obj['cateogryMeals'];
    this._statusFav = obj['statusFav'];
  }

  String get idMeal => _idMeal;
  String get strMeal => _strMeal;
  String get strMealThumb => _strMealThumb;
  String get categoryMeals => _categoryMeals;
  String get statusFav => _statusFav;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    map['idMeal'] = _idMeal;
    map['strMeal'] = _strMeal;
    map['strMealThumb'] = _strMealThumb;
    map['categoryMeals'] = _categoryMeals;
    map['statusFav'] = _statusFav;

    return map;
  }

  void setFavoriteId(int id){
    this.id = id;
  }
}