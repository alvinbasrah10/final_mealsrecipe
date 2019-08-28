class Detail {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final String strDrinkAlternate;
  final String strCategory;
  final String strArea;
  final String strTags;
 
  Detail({this.idMeal, this.strMeal, this.strMealThumb, this.strInstructions, this.strDrinkAlternate, this.strCategory, this.strArea, this.strTags});
 
  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
    idMeal:  json['idMeal'], 
    strMeal:  json['strMeal'],
    strMealThumb:  json['strMealThumb'],
    strInstructions:  json['strInstructions'],
    strDrinkAlternate: json['strDrinkAlternate'],
    strCategory: json['strCategory'],
    strArea: json['strArea'],
    strTags: json['strTags']);
  }
}