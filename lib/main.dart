import 'package:flutter/material.dart';
import 'package:recipes_android/pages/home.dart';
import 'package:recipes_android/pages/recipe.dart';

void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => Home(),
            transitionDuration: Duration.zero,
          );
        } else if (settings.name == '/recipe') {
          final args = settings.arguments as Map;
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                Recipe(recipes: args['recipes'], i: args['i']),
            transitionDuration: Duration.zero,
          );
        }
      },
    ),
  );
}
