import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:portfolio/home.dart';
import 'package:url_launcher/url_launcher.dart';

import '../modal.dart';

Future<void> getRecipe(Map info,String query, Function setState ) async {

  print("isGeneratingRandom");
  print(info["isGeneratingRandom"]);

  setState(() {
    info["recipeList"] = [];
    info["isDataNotFetched"] = true;
    info["hasMore"] = true;
    info["isGeneratingRandom"] = false;

  });

  final String appId = "b1b07860";
  final String appKey = "eda0c72c38e79489a794fe21cab6df2c";
  final String userId = "Aman";

  final Uri url = Uri.parse(
    'https://api.edamam.com/api/recipes/v2?type=public&q=$query&app_id=$appId&app_key=$appKey',
  );

  try {
    final response = await get(
      url,
      headers: {
        'accept': 'application/json',
        'Edamam-Account-User': userId,
        'Accept-Language': 'en',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        info["isDataNotFetched"] = false;
        info["recipeList"] = [];
        info["recipesFound"] = data['count'].toString();
      });

      for (var hit in data['hits']) {
        RecipeResult recipeResult = RecipeResult.fromMap(hit);
        info["recipeList"].add(recipeResult);
      }

      info["nextURI"] = data['_links']?['next']?['href'] ?? "";
      if (info["nextURI"].trim().isEmpty) {
        info["hasMore"] = false;
      } else {
        setState(() {
          info["hasMore"] = true;
        });
      }
      setState(() {
        info["isLoading"] = false;
      });
    } else {
      setState(() {
        info["isDataNotFetched"] = false;
        info["recipesFound"] = "Error fetching data";
        info["isLoading"] = false;
      });
      throw Exception('Failed to load recipes');
    }
  } catch (e) {
    setState(() {
      info["isDataNotFetched"] = false;
      info["recipesFound"] = "Error occurred";
      info["isLoading"] = false;
    });
    print("Error: $e");
  }
}

Future<void> getRandomRecipe(Map info,String query, Function setState) async {

  print(" before isGeneratingRandom");
  print(info["isGeneratingRandom"]);

  setState(() {
    info["recipeList"] = [];
    info["isDataNotFetched"] = true;
    info["hasMore"] = true;
  });

  final String appId = "b1b07860";
  final String appKey = "eda0c72c38e79489a794fe21cab6df2c";
  final String userId = "Aman";

  List<String> randomKeywords = [
    'chicken',
    'pasta',
    'vegan',
    'dessert',
    'salad',
    'pizza',
    'soup',
    'cake',
    'indian',
    'chinese',
    'ice cream',
    'Dal',
    'Paneer',
    'Roll',
    'Pasta',
    'breakfast',
    'salad',
    'sandwich'
    ''
  ];
  String randomKeyword =
  randomKeywords[Random().nextInt(randomKeywords.length)];

  final Uri url = Uri.parse(
    'https://api.edamam.com/api/recipes/v2?type=public&q=$randomKeyword&app_id=$appId&app_key=$appKey&imageSize=LARGE&random=true',
  );

  try {
    final response = await get(
      url,
      headers: {
        'accept': 'application/json',
        'Edamam-Account-User': userId,
        'Accept-Language': 'en',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        info["isDataNotFetched"] = false;
        info["recipeList"] = [];
        info["recipesFound"] = data['count'].toString();
      });

      for (var hit in data['hits']) {
        RecipeResult recipeResult = RecipeResult.fromMap(hit);
        info["recipeList"].add(recipeResult);
      }

      info["nextURI"] = data['_links']?['next']?['href'] ?? "";
      if (info["nextURI"].trim().isEmpty) {
        info["hasMore"] = false;
      } else {
        setState(() {
          info["hasMore"] = true;
        });
      }
      setState(() {
        info["isLoading"] = true;
      });

      print("after isGeneratingRandom");
      print(info["isGeneratingRandom"]);
    } else {
      setState(() {
        info["isDataNotFetched"] = false;
        info["recipesFound"] = "Error fetching data";
        info["isLoading"] = true;
      });
      throw Exception('Failed to load recipes');
    }
  } catch (e) {
    setState(() {
      info["isDataNotFetched"] = false;
      info["recipesFound"] = "Error occurred";
      info["isLoading"] = true;
    });
    print("Error: $e");
  }
}

Future<void> loadMorePages(Map info,String url,Function setState) async {
  print("Inside Load More Pages function");
  if (info["isLoading"] || !info["hasMore"]) return;
  setState(() {
    info["isLoading"] = true;
  });
  print("Inside Load More Pages function");

  Uri uri = Uri.parse(url);
  final response = await get(uri, headers: {
    'accept': 'application/json',
    'Edamam-Account-User': "aditya",
    'Accept-Language': 'en',
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final totalResults = data['count'];

    for (var hit in data['hits']) {
      RecipeResult recipeResult = RecipeResult.fromMap(hit);
      info["recipeList"].add(recipeResult);
    }

    info["nextURI"] = data['_links']?['next']?['href'];
    if (info["nextURI"].isEmpty) {
      info["hasMore"] = false; // No more pages
    }
  } else {
    setState(() {
      info["hasMore"] = false;
    });
  }

  setState(() {
    info["isLoading"] = false;
  });
}

Future<void> _launchURL(String url) async {
  //Convert the String into a URI
  final Uri uri = Uri.parse(url);

  //Check for a valid App/Browser to open
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}