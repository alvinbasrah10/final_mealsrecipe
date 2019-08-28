class Ingredients{
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
   
  Ingredients({this.idMeal, this.strMeal, this.strMealThumb});
  factory Ingredients.fromJson(Map<String, dynamic> json){
    return Ingredients(
    idMeal:  json['idMeal'], 
    strMeal:  json['strMeal'],
    strMealThumb:  json['strMealThumb']);
  }
}