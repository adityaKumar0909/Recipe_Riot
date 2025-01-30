import 'package:flutter/material.dart';



class RecipeResult {
  String title = "";
  String imageURI = "";
  String id = "";
  List<String> ingredients = [];
  String calories = "";
  List<String> dietLabels = [];
  List<Map<String,dynamic>> totalDaily=[];
  List<Map<String,dynamic>> nutrientGain=[];

  String sourceURI = "";
  String cuisine="";

  RecipeResult({
    this.id = "XXX",
    this.imageURI = "XXX",
    this.title = "titleXXX",
    this.ingredients = const [],
    this.calories = "XXX",
    this.dietLabels = const [],
    this.sourceURI = "XXX",
    this.cuisine ="XXX",
    this.totalDaily=const [],
    this.nutrientGain=const [],

  });

  factory RecipeResult.fromMap(Map recipe) {

    List<String> ingredientsList = [];
    if (recipe["recipe"]["ingredientLines"] != null) {
      ingredientsList = List<String>.from(recipe["recipe"]["ingredientLines"]);
    }

    List<Map<String,dynamic>> dailyList=[];
    if(recipe["recipe"]["totalDaily"]!= null){
      recipe["recipe"]["totalDaily"].forEach((key,value){
        dailyList.add(
          {
            "label":value["label"] ?? "X",
            "quantity":value["quantity"] ?? 0.0,
            "unit":value["unit"]??"",
          }
        );
      });
    }

    List<Map<String,dynamic>> nutrientList=[];
    if(recipe["recipe"]["totalNutrients"]!= null){
      recipe["recipe"]["totalNutrients"].forEach((key,value){
        nutrientList.add(
            {
              "label":value["label"] ?? "X",
              "quantity":value["quantity"] ?? 0.0,
              "unit":value["unit"]??"",
            }
        );
      });
    }


    //print("Ingredients extracted: $ingredientsList");

    return RecipeResult(
      nutrientGain: nutrientList,
      totalDaily:dailyList,
      cuisine: recipe["recipe"]["cuisineType"][0] ?? "unknown",
      title: recipe["recipe"]["label"] ?? "",
      id: recipe["recipe"]["uri"] ?? "",
      imageURI: recipe["recipe"]["images"]["REGULAR"]["url"] ?? "https://img.freepik.com/free-vector/404-error-with-portals-concept-illustration_114360-7970.jpg?t=st=1731181742~exp=1731185342~hmac=5df2f7a42becc998dc3d03ab1734c076eed1e0cabc45f3a6900c7c709fa9a7e6&w=740",
      ingredients: ingredientsList,
      calories: recipe["recipe"]["calories"].toStringAsFixed(2) ?? "NA",
      dietLabels: List<String>.from(recipe["recipe"]["dietLabels"] ?? []),
      sourceURI: recipe["recipe"]["url"] ?? "",
    );
  }
}




