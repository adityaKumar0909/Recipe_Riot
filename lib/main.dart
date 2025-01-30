import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio/dishPage.dart';
import 'package:portfolio/introPage.dart';
import 'home.dart';
import 'package:get/get.dart';

void main() {
  //For page navigation
  runApp(const GetMaterialApp(
    home: introPage(),
    debugShowCheckedModeBanner: false,
  ));
}
