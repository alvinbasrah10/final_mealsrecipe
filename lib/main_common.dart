import 'package:flutter/material.dart';
import 'package:final_mealsrecipe/homepage.dart';
import 'package:final_mealsrecipe/app_config.dart';


void mainCommon() {

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    return _buildApp(config.appDisplayName);
  }

  Widget _buildApp(String appName) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primaryColor: Color(0xFF43a047),
        accentColor: Color(0xFFffcc00),
        primaryColorBrightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}