import 'package:flutter/material.dart';
import 'package:final_mealsrecipe/app_config.dart';
import 'package:final_mealsrecipe/main_common.dart';
import 'package:final_mealsrecipe/resource/display_strings_app2.dart';

void main() {
  var configuredApp = AppConfig(
    appDisplayName: "Meals Recipe Release",
    appInternalId: 2,
    stringResource: StringResourceApp2(),
    child: MyApp(),
  );

  mainCommon();
  runApp(configuredApp);
}