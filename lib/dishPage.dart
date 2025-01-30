import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'modal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:vibration/vibration.dart';

class dishPage extends StatefulWidget {
  const dishPage({super.key});

  @override
  State<dishPage> createState() => _dishPageState();
}

class _dishPageState extends State<dishPage> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final recipe = Get.arguments;
    print("Ingredients received: ${recipe.ingredients}");
    String title = recipe.title;
    String cuisine = recipe.cuisine;
    String uri = recipe.sourceURI;
    var ingredients = recipe.ingredients;
    print("ingredients:$ingredients");
    String calories=recipe.calories;
    var nutrients=recipe.nutrientGain;
    var dailyTotal=recipe.totalDaily;

    Future<void> launchURL(String url) async {
      //Convert the String into a URI
      final Uri uri = Uri.parse(url);
      print("Going to launch alternative page");



      await launchUrl(uri);

    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),

                //==============Dish Title===========================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: screenWidth,
                        child: Text("$title",
                            style: TextStyle(
                              fontSize: screenWidth * 0.095,
                              // Responsive font size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.04,
                    ),

                    Center(
                      child: Container(
                        width: screenWidth * 0.85,
                        height: screenHeight * 0.0008,
                        decoration: BoxDecoration(color: Colors.black),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    //============Ingredients=========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: screenWidth,
                        child: Text("Ingredients",
                            style: TextStyle(
                              fontSize: screenWidth * 0.075,
                              // Responsive font size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    //==========PageView for Ingredients==============================

                    Container(
                      height: screenHeight * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  width: screenWidth * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.1,
                                              vertical: screenHeight * 0.05,
                                            ),
                                            child: Text(
                                              ingredients[index],
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.065,
                                                // Responsive font size
                                                fontFamily: 'FontMain',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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

                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    //===========Dont have all the ingredients?=======================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        width: screenWidth,
                        child: Text("Don't have all the ingredients?",
                            style: TextStyle(
                              fontSize: screenWidth * 0.055,
                              // Responsive font size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    //=================Look Alternatives============================

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => {
                            if(Vibration.hasVibrator()!=null){
                              Vibration.vibrate(duration: 100),
                            },
                            launchURL("https://www.allrecipes.com/article/common-ingredient-substitutions/"),

                          },
                          child: Container(
                            width: screenWidth - 80,
                            height: screenHeight * 0.070,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                "Look alternatives",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'FontMain',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    //===========Buy==============================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        width: screenWidth,
                        child: Text("Buy Ingredients",
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.055,
                              // Responsive font size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.03,
                    ),

                    //=======App Buttons=================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                      Row(

                        //swiggy
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => {
                              if(Vibration.hasVibrator()!=null){
                                Vibration.vibrate(duration: 100),
                              },
                              launchURL(
                                "https://www.swiggy.com/")},
                            child: Container(
                              width: screenHeight * 0.08,
                              height: screenHeight * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "images/swiggy.png",
                                  scale: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.03,
                      ),
                      Row(
                        //blinkit
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => {
                              if(Vibration.hasVibrator()!=null){
                                Vibration.vibrate(duration: 100),
                              },
                              launchURL(
                                "https://blinkit.com/")},
                            child: Container(
                              width: screenHeight * 0.08,
                              height: screenHeight * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "images/blinkit.png",
                                  scale: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.03,
                      ),
                      Row(
                        //Zepto
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => {
                              if(Vibration.hasVibrator()!=null){
                                Vibration.vibrate(duration: 100),
                              },
                              launchURL(
                                "https://www.zeptonow.com/")},
                            child: Container(
                              width: screenHeight * 0.08,
                              height: screenHeight * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "images/zepto.png",
                                  scale: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.03,
                      ),
                      Row(
                        //Bigbasket
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => {
                              if(Vibration.hasVibrator()!=null){
                                Vibration.vibrate(duration: 100),
                              },
                              launchURL(
                                "https://www.bigbasket.com/")},
                            child: Container(
                              width: screenHeight * 0.08,
                              height: screenHeight * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "images/bigbasket.png",
                                  scale: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),


                    ]
                    ),
                    SizedBox(
                      height: screenHeight*0.05,
                    ),
                    //========Cooking Link========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        width: screenWidth,
                        child: Text("Cooking Instructions",
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.055,
                              // Responsive font size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    //==============================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => {
                            if(Vibration.hasVibrator()!=null){
                              Vibration.vibrate(duration: 100),
                            },
                            launchURL(uri),},
                          child: Container(
                            width: screenWidth - 80,
                            height: screenHeight * 0.070,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                "Visit Site",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'FontMain',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    //============Know your Food  ================================

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text("Know Your Food ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.055,
                        fontFamily: 'FontMain',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                    ),

                    SizedBox(
                      height: screenHeight * 0.03,
                    ),

                    //============Nutritional Card================================

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Card(
                        shadowColor: Colors.grey,
                        elevation: 10,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Nutrional Facts
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Nutritional Facts",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.08,
                                    fontFamily: 'FontMain',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  )
                                ],
                              ),

                              Divider(thickness: 10,color: Colors.white24),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Text("Amount Per Serving",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontFamily: 'FontMain',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Expanded(
                                        child: Text("Calories",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.065,
                                          fontFamily: 'FontMain',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),),
                                      ),

                                      //SizedBox(width: screenWidth*0.25,),

                                      Text("$calories",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.065,
                                        fontFamily: 'FontMain',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),),
                                    ],
                                  ),
                                  Divider(thickness: 7,color: Colors.white24,),

                                  Row(
                                    children: [
                                      SizedBox(width: screenWidth*0.57,),

                                      Text("%Daily Value*",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.025,
                                        fontFamily: 'FontMain',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),),
                                    ],
                                  ),
                                  Divider(thickness: 3,color: Colors.white24,),
                                ],
                              ),

                              LabelRow(context, "Total Fat: ", nutrients[1]["quantity"].toStringAsFixed(1),nutrients[1]["unit"],dailyTotal[1]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "   Saturated Fat: ",nutrients[2]["quantity"].toStringAsFixed(1),nutrients[2]["unit"], dailyTotal[2]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "   Trans Fat: ", nutrients[3]["quantity"].toStringAsFixed(1),nutrients[3]["unit"],  dailyTotal[3]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Cholestrol: ", nutrients[12]["quantity"].toStringAsFixed(1),nutrients[12]["unit"] ,dailyTotal[12]["quantity"].toStringAsFixed(0)),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Sodium", nutrients[13]["quantity"].toStringAsFixed(1), nutrients[13]["unit"],  dailyTotal[13]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Carbohydrate: ", nutrients[7]["quantity"].toStringAsFixed(1), nutrients[7]["unit"],  dailyTotal[7]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Fiber: ", nutrients[8]["quantity"].toStringAsFixed(1),  nutrients[8]["unit"], dailyTotal[8]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Sugar: ", nutrients[9]["quantity"].toStringAsFixed(1),  nutrients[9]["unit"], dailyTotal[9]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Protein: ", nutrients[11]["quantity"].toStringAsFixed(1),  nutrients[11]["unit"], dailyTotal[11]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Calcium: ", nutrients[14]["quantity"].toStringAsFixed(1),  nutrients[14]["unit"], dailyTotal[14]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Magnesium: ", nutrients[15]["quantity"].toStringAsFixed(1),  nutrients[15]["unit"], dailyTotal[15]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              LabelRow(context, "Iron: ", nutrients[17]["quantity"].toStringAsFixed(1),  nutrients[17]["unit"], dailyTotal[17]["quantity"].toStringAsFixed(0) ),
                              Divider(thickness: 2,color: Colors.white24,),
                              //LabelRow(context, "Vitamin D: ", nutrients[30]["quantity"].toStringAsFixed(1),  nutrients[30]["unit"], dailyTotal[30]["quantity"].toStringAsFixed(0) ),

                              SizedBox(height: screenHeight*0.05,),

                              // Divider(thickness: 2,color: Colors.white24,),
                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}



 Container LabelRow(BuildContext context ,String label , String inContentQuantity , String labelUnit, String DailyRequirementPercentage){
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Container(
    width: screenWidth,
  child:Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      Expanded(
        child: Text("$label",
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontFamily: 'FontMain',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
      ),

      Expanded(
        child: Text("$inContentQuantity $labelUnit",
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontFamily: 'FontMain',
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),),
      ),

      //SizedBox(width: screenWidth*distanceBetweenTexts,),
      Text(" $DailyRequirementPercentage%",
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          fontFamily: 'FontMain',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
    ],
  ),
);
}

