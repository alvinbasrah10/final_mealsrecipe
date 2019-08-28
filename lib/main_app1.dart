import 'package:flutter/material.dart';
import 'package:final_mealsrecipe/app_config.dart';
import 'package:final_mealsrecipe/main_common.dart';
import 'package:final_mealsrecipe/resource/display_strings_app1.dart';

void main() {
  var configuredApp = AppConfig(
    appDisplayName: "Meals Recipe Debug",
    appInternalId: 1,
    stringResource: StringResourceApp1(),
    child: MyApp(),
  );

  mainCommon();
  runApp(configuredApp);
}