import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:portfolio/home.dart';
import 'package:vibration/vibration.dart';



class introPage extends StatefulWidget {
  const introPage({super.key});

  @override
  State<introPage> createState() => _introPageState();
}

class _introPageState extends State<introPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
          child: Stack(
            children: <Widget>[
              //Setting the background white
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  color: Color(0xff000000),
                ),
              ),

              //==============Logo====================================================

              Positioned(
                  left: 0,
                  right: 0,
                  top: screenHeight * 0.01,
                  child: Container(
                    child: Image.asset(
                      "images/stewLogo.png",
                      scale: 4,
                    ),
                  )),

              Positioned(
                top: screenHeight * 0.45,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "2 Million+ Recipes",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      // Responsive font size
                      fontFamily: 'FontMain',
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              Positioned(
                  top: screenHeight * 0.5,
                  child: Container(
                    width: screenWidth,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            "It's Cooking Time!",
                            style: TextStyle(
                              fontSize: screenWidth * 0.15,
                              // Responsive font size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

              Positioned(
                  left: 0,
                  right: 0,
                  top: screenHeight * 0.825,
                  child: Center(
                    child: InkWell(
                      onTap: ()=>{
                        if(Vibration.hasVibrator()!=null){
                          Vibration.vibrate(duration: 100),
                        },
                        Get.off(()=>Home(),transition: Transition.circularReveal,duration: Duration(milliseconds: 1000)),
                      },
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.1,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(70)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Get Started",
                            style: TextStyle(
                              fontSize: screenWidth * 0.075,
                              // Responsive font size
                              fontFamily: 'FontMain',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
