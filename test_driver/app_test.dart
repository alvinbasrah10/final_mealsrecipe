// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:test/test.dart';
import 'package:flutter_driver/flutter_driver.dart';

void main() {
  group(('Skenario Test'), (){
    //deklarasi semua key
    final navbarDesert = find.byValueKey('choose_desert');
    final appbarDesert = find.byValueKey('desert_list');
    final appbarSeafood = find.byValueKey('seafood_list');
    final iconSea = find.byValueKey('icon_sea');
    final gridSeafood = find.byValueKey('gridview_seafood');
    final detailPage = find.byValueKey('detail_page');
    final favorited = find.byValueKey('favorited');
    final responseFav = find.byValueKey('response_fav');
    final backBtn = find.byValueKey('kembali');
    final iconFav = find.byValueKey('icon_fav');
    final appbarFav = find.byValueKey('favorite_page');
    final iconSeaFav = find.byValueKey('icon_seafood');
    final gridFav = find.byValueKey('gridfav_seafood');
    final appbardetailFav = find.byValueKey('appbardetail_fav');
    final btnDel = find.byValueKey('delete');
    final dialogDel = find.byValueKey('tombol_delete');
    final btnSearch = find.byValueKey('search_icon');
    final textSearch = find.byValueKey('text_search');
    final searchPage = find.byValueKey('search_meals');
    final fabSearch = find.byValueKey('float_search');
    final btnbackSearch = find.byValueKey('back_fromsearch');
    final listSearch = find.byValueKey('list_search');
    final headSearch = find.byValueKey('head_search');
    final buttonDel = find.byValueKey('btn_delete');

    FlutterDriver driver;

    //connect
    setUpAll(() async{
      driver = await FlutterDriver.connect();
    });

    //dissconnect
    tearDownAll(() async{
      if(driver != null){
        driver.close();
      }
    });

    //test section
    test('starts at 0', () async {  
    expect(await driver.getText(navbarDesert), "Desert");
    expect(await driver.getText(appbarDesert), "Desert List");
    });

    test('pilih navbaritem', () async{
      await driver.tap(iconSea);
      expect(await driver.getText(appbarSeafood), 'Seafood List');
    });

    test('klik gridview', () async {
      await driver.tap(gridSeafood);
      expect(await driver.getText(detailPage), 'Detail Ingredients');

    });

    test('favorited', () async {
     await driver.tap(favorited);
     expect(await driver.getText(responseFav), 'Added to favorite'); 
    });

    test('kembali', () async{
      await driver.tap(backBtn);
      expect(await driver.getText(appbarSeafood), 'Seafood List');
      await Future.delayed(Duration(seconds: 5), (){
      });
    });

    test('search page', () async{
      await driver.tap(btnSearch);
      expect(await driver.getText(searchPage), 'Search Meals');
    });

    test('search something', () async {
      await driver.tap(textSearch);
      await driver.enterText('pudding');
      await driver.waitFor(find.text('pudding'));
      await driver.tap(fabSearch);

      await Future.delayed(Duration(seconds: 3), (){
      });
      expect(await driver.getText(headSearch), 'Search Page');
    });

    test('click something on search', () async{
      await driver.tap(listSearch);
      expect(await driver.getText(detailPage), 'Detail Ingredients');
    });

    test('back from search detail page', () async{
      await Future.delayed(Duration(seconds: 5), (){
      });
      await driver.tap(backBtn);
      expect(await driver.getText(headSearch), 'Search Page');
    });

    test('back from search', () async {
      await driver.tap(btnbackSearch);
      await Future.delayed(Duration(seconds: 5), (){
      });
      expect(await driver.getText(appbarSeafood), 'Seafood List');
    });

    test('favorite list page', () async {
      await driver.tap(iconFav);
      expect(await driver.getText(appbarFav), 'Favorite Page');
    });

    test('choose seafood fav page', () async {
      await driver.tap(iconSeaFav);
      expect(await driver.getText(appbarFav), 'Favorite Page');
    });
    
    test('klik grid favorite', () async {    
      await driver.tap(gridFav);
      expect(await driver.getText(appbardetailFav), 'Detail Favorite Ingredients');
    });

    test('dialog delete favorite', () async {
      await driver.tap(btnDel);
      expect(await driver.getText(dialogDel), 'Delete');
    });

    test('delete favorite', () async{
      await driver.tap(buttonDel);
      expect(await driver.getText(appbarFav), 'Favorite Page');
    });
  });
}