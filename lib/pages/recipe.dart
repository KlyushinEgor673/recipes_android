import 'package:flutter/material.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key, required this.recipes, required this.i});

  final List<Map> recipes;
  final int i;

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipes[widget.i]['name']),
      ),
    );
  }
}
