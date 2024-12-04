import 'package:flutter/material.dart';

class CategoriesModel {
  String name;
  IconData iconText;

  CategoriesModel({required this.name, required this.iconText});

  static List<CategoriesModel> getCategories() {
    List<CategoriesModel> categories = [];

    categories.add(
        CategoriesModel(name: "Mental Hobbies", iconText: Icons.psychology));
    categories.add(CategoriesModel(
        name: "Physical Hobbies", iconText: Icons.directions_run));
    categories
        .add(CategoriesModel(name: "Creative Hobbies", iconText: Icons.brush));
    categories.add(
        CategoriesModel(name: "Musical Hobbies", iconText: Icons.music_note));
    categories.add(
        CategoriesModel(name: "Collective Hobbies", iconText: Icons.groups));
    categories.add(
        CategoriesModel(name: "Games & Puzzles", iconText: Icons.extension));
    return categories;
  }
}
