//Useful Libraries
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:developer';
import 'dishPage.dart';
import 'modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'data_fetching/dataFetch.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //===================Variables================================================

  final String appId = "b1b07860";
  final String appKey = "eda0c72c38e79489a794fe21cab6df2c"; //  API Key
  final String userId = "Viraj";

  // bool isLoading = false;
  //bool hasMore = true;
  int from = 0;
  final int pageSize = 20;
  ScrollController _scrollController = ScrollController();

  //For Page View
  PageController _pageController = PageController();

  //For TextField
  final TextEditingController _controller = TextEditingController();

  //For storing Search Query
  String searchQuery = "";

  //For Filters
  bool isFiltersActive = false;
  bool isCuisinesActive = false;

  //============================================================================

  Map<dynamic, dynamic> info = {
    "isLoading": false,
    "hasMore": true,
    "isDataNotFetched": true,
    "recipeList": <RecipeResult>[],
    "isGeneratingRandom": true,
    "recipesFound": "",
    "nextURI": "",
  };

  Map<String, bool> filters = {
    "isVegetarian": false,
    "isVegan": false,
    "isEggFree": false,
    "isDairyFree": false,
    "isGlutenFree": false,
    "isKetoFriendly": false,
    "isLowFat": false,
    "isLowSugar": false,
  };

  Map<String, bool> cuisine = {
    "isAmerican": false,
    "isAsian": false,
    "isBritish": false,
    "isCaribbean": false,
    "isChinese": false,
    "isFrench": false,
    "isIndian": false,
    "isItalian": false,
    "isJapanese": false,
  };

  //============================================================================

  //----------------------------------------------------------------------------

  void _pageChangeListener() {
    if (_pageController.page == info["recipeList"].length - 1) {
      print("reached end");
      print("isLoading : ${info["isLoading"]} hasMore : ${info["hasMore"]}");
      if (info["hasMore"] && !info["isLoading"]) {
        print("going to call load more pages");
        loadMorePages(info, info["nextURI"], setState);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    //_scrollController.addListener(_scrollListener);
    _pageController.addListener(_pageChangeListener);
    getRandomRecipe(info, "", setState);
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //Fetch Screen Resolution
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              // Background color=================================================
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              //==================================================================

              // Title text
              Positioned(
                top: screenHeight * 0.045,
                // Adjusted position based on screen height
                left: screenWidth * 0.050,
                right: screenWidth * 0.050,
                child: Container(
                  width: screenWidth,
                  child:
                      TextR("What will you like to cook ?", screenWidth * 0.1),
                ),
              ),

              //==================================================================
              // Search Container
              Positioned(
                top: screenHeight * 0.18, // Adjusted for responsiveness
                left: screenWidth * 0.030,
                right: screenWidth * 0.030,

                child: Container(
                  height: screenHeight * 0.1, // Dynamic height
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(65),
                  ),

                  child: Row(
                    children: <Widget>[
                      // Search Icon
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: IconButton(
                          onPressed: () => {
                            if (Vibration.hasVibrator() != null)
                              {Vibration.vibrate(duration: 100)},
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Container(
                                        width: screenWidth,
                                        // height: screenHeight*0.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                        ),
                                        child: StatefulBuilder(
                                          builder:
                                              (BuildContext context, setState) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 30,
                                                      horizontal: 30),
                                              child: Column(
                                                children: <Widget>[
                                                  // Apply Filters
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextR("Apply filters",
                                                          screenHeight * 0.035),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Switch(
                                                        value: isFiltersActive,
                                                        onChanged: (
                                                          bool value,
                                                        ) {
                                                          if (Vibration
                                                                  .hasVibrator() !=
                                                              null) {
                                                            Vibration.vibrate(
                                                                duration: 100);
                                                          }
                                                          setState(
                                                            () {
                                                              isFiltersActive =
                                                                  value;
                                                            },
                                                          );
                                                        },
                                                        activeColor:
                                                            Colors.black,
                                                        inactiveThumbColor:
                                                            Colors.white,
                                                      )
                                                    ],
                                                  ),

                                                  Divider(
                                                    thickness: 2,
                                                    color: Colors.black,
                                                  ),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Vegetarian",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters["isVegetarian"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isVegetarian"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Vegan",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters["isVegan"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isVegan"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Egg-free",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters["isEggFree"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isEggFree"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Dairy-free",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters["isDairyFree"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isDairyFree"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Gluten-free",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters["isGlutenFree"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isGlutenFree"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Keto-friendly",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters[
                                                          "isKetoFriendly"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isKetoFriendly"] =
                                                          value;
                                                    });
                                                  }),
                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Low-fat",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters["isLowFat"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isLowFat"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Low-sugar",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      filters["isLowSugar"]!,
                                                      (value) {
                                                    setState(() {
                                                      filters["isLowSugar"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  Divider(
                                                      thickness: 2,
                                                      color: Colors.black),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      Expanded(
                                                          child: TextR(
                                                              "Cuisines",
                                                              screenHeight *
                                                                  0.037)),
                                                      // SizedBox(width: 20,),
                                                      Switch(
                                                        value: isCuisinesActive,
                                                        onChanged: (
                                                          bool value,
                                                        ) {
                                                          if (Vibration
                                                                  .hasVibrator() !=
                                                              null) {
                                                            Vibration.vibrate(
                                                                duration: 100);
                                                          }
                                                          setState(
                                                            () {
                                                              isCuisinesActive =
                                                                  value;
                                                            },
                                                          );
                                                        },
                                                        activeColor:
                                                            Colors.black,
                                                        inactiveThumbColor:
                                                            Colors.white,
                                                      )
                                                    ],
                                                  ),

                                                  Divider(
                                                      thickness: 2,
                                                      color: Colors.black),

                                                  textSwitch(
                                                      "American",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isAmerican"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isAmerican"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Asian",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isAsian"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isAsian"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "British",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isBritish"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isBritish"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Caribbean",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isCaribbean"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isCaribbean"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Chinese",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isChinese"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isChinese"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "French",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isFrench"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isFrench"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Indian",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isIndian"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isIndian"] =
                                                          value;
                                                    });
                                                  }),
                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Italian",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isItalian"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isItalian"] =
                                                          value;
                                                    });
                                                  }),
                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),

                                                  textSwitch(
                                                      "Japanese",
                                                      screenHeight * 0.02,
                                                      screenHeight * 0.01,
                                                      cuisine["isJapanese"]!,
                                                      (value) {
                                                    setState(() {
                                                      cuisine["isJapanese"] =
                                                          value;
                                                    });
                                                  }),

                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                })
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: screenWidth * 0.08, // Scalable size
                          ),
                        ),
                      ),
                      // TextField
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.start,
                            cursorColor: Colors.white,
                            cursorHeight: 25,
                            onSubmitted: (String searchQuery_) {
                              if (Vibration.hasVibrator() != null) {
                                Vibration.vibrate(duration: 100);
                              }
                              if (!searchQuery_.isEmpty ||
                                  !searchQuery_.trim().isEmpty) {
                                getRecipe(info, searchQuery_, setState);
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Let's cook something!",
                              hintStyle: TextStyle(
                                fontSize: screenWidth * 0.05,
                                // Scalable hint text
                                fontFamily: 'FontMain',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              // Scalable text size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //==================================================================

              //total queries

              Container(
                child: Positioned(
                  left: screenWidth * 0.050,
                  right: screenWidth * 0.050,
                  top: screenHeight * 0.3,
                  child: (info["isGeneratingRandom"])
                      ? (info["isDataNotFetched"])
                          ? Text("")
                          : TextG("Try these ...", screenWidth * 0.08)
                      : TextG("Recipes found : ${info["recipesFound"]}",
                          screenWidth * 0.08),
                ),
              ),
              //==================================================================
              // Recipe display using PageView for responsiveness

              Positioned(
                left: 0,
                right: 0,
                top: screenHeight * 0.37, // Dynamic top position
                child: Container(
                  height: screenHeight * 0.55,
                  // Adjust container height dynamically
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ((_controller.text).isEmpty)
                      ? PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          itemCount: info["recipeList"].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  if (Vibration.hasVibrator() != null) {
                                    Vibration.vibrate(duration: 100);
                                  }
                                  Get.to(() => dishPage(),
                                      transition: Transition.circularReveal,
                                      duration: Duration(milliseconds: 700),
                                      arguments: info["recipeList"][index]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    //Outter Black container

                                    height:
                                        screenHeight * 0.5, // Scalable height
                                    width: screenWidth - 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(70),
                                    ),

                                    child: Column(
                                      children: <Widget>[
                                        //Recipe Image
                                        SizedBox(height: screenHeight * 0.027),
                                        // Scalable space
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          child: Container(
                                            width: screenWidth * 0.80,
                                            // Scalable width
                                            height: screenHeight * 0.30,
                                            // Scalable image size
                                            child: Image.network(
                                              info["recipeList"][index]
                                                  .imageURI,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.1,
                                              vertical: screenHeight * 0.05),
                                          child: Text(
                                            info["recipeList"][index].title,
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.06,
                                                // Scalable font size
                                                fontFamily: 'FontMain',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _pageController,
                          itemCount: info["recipeList"].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  if (Vibration.hasVibrator() != null) {
                                    Vibration.vibrate(duration: 100);
                                  }
                                  Get.to(() => dishPage(),
                                      transition: Transition.circularReveal,
                                      duration: Duration(milliseconds: 700),
                                      arguments: info["recipeList"][index]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    //Outter Black container

                                    height:
                                        screenHeight * 0.5, // Scalable height
                                    width: screenWidth - 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(70),
                                    ),

                                    child: Column(
                                      children: <Widget>[
                                        //Recipe Image
                                        SizedBox(height: screenHeight * 0.027),
                                        // Scalable space
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          child: Container(
                                            width: screenWidth * 0.80,
                                            // Scalable width
                                            height: screenHeight * 0.30,
                                            // Scalable image size
                                            child: Image.network(
                                              info["recipeList"][index]
                                                  .imageURI,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.1,
                                              vertical: screenHeight * 0.05),
                                          child: Text(
                                            info["recipeList"][index].title,
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.06,
                                                // Scalable font size
                                                fontFamily: 'FontMain',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Text TextR(String text, double size) {
  return Text(
    "$text",
    style: TextStyle(
      fontSize: size,
      // Scalable font size
      fontFamily: 'FontMain',
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}

Text TextG(String text, double size) {
  return Text(
    "$text",
    style: TextStyle(
      fontSize: size,
      // Scalable font size
      fontFamily: 'FontMain',
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );
}

Text TextW(String text, double size) {
  return Text(
    "$text",
    style: TextStyle(
      fontSize: size,
      // Scalable font size
      fontFamily: 'FontMain',
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}

Row textSwitch(String text, double fontSize, double gapSize, bool variableName,
    Function(bool) setState) {
  return Row(
    children: [
      Expanded(child: TextR(text, fontSize)),
      // SizedBox(width: 20,),
      Switch(
        value: variableName,
        onChanged: (
          bool value,
        ) {
          if (Vibration.hasVibrator() != null) {
            Vibration.vibrate(duration: 100);
          }
          setState(value);
        },
        activeColor: Colors.black,
        inactiveThumbColor: Colors.white,
      ),
    ],
  );
}
