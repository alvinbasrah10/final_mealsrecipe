import 'dart:convert';

import 'package:final_mealsrecipe/model/ingredients.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
  
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {

  group('loadData', () {
    test('Menampilkan sebuah post jika data berhasil diambil', () async {
      final client = MockClient();
      
      //gunakan mockito
      when(client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert'))
          .thenAnswer((_) async => http.Response('{"meals":[{"strMeal":"Apple & Blackberry Crumble","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/xvsurr1511719182.jpg","idMeal":"52893"},{"strMeal":"Apple Frangipan Tart","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/wxywrq1468235067.jpg","idMeal":"52768"}]}', 200));

      expect(await loadData(client), isInstanceOf<Ingredients>());
    });
    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert'))
          .thenAnswer((_) async => http.Response('{"meals":null}', 404));

      expect(loadData(client), throwsException);
    });
  });
}

Future<Ingredients> loadData(http.Client client) async {
  final response =
      await client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Ingredients.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
