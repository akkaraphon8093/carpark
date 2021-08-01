import 'package:flutter/material.dart';

class MyConstant {
  
  //Genernal
  static String appName = 'CarPark';

  //Route
  static String routeAuthen = '/authen';
  static String routeCreatAccount = '/creatAccount';
  static String routeBuyerService = 'buyerService';
  static String routeSalerService = 'salerService';
  static String routeRiderService = 'riderService';

  //Image
  static String image1= 'images/image1.png';
  static String image2= 'images/image2.png';
  static String image3= 'images/image3.png';
  static String image4= 'images/image4.png';

  //color
  static Color primary = Color(0xff29abe1);
  static Color dark = Color(0xff007caf);
  static Color light = Color(0xff6fddff);

  //Style
  TextStyle h1Style() => TextStyle(
    fontSize: 24,
    color: dark,
    fontWeight: FontWeight.bold,
  );
   TextStyle h2Style() => TextStyle(
    fontSize: 18,
    color: dark,
    fontWeight: FontWeight.w700,
  );
   TextStyle h3Style() => TextStyle(
    fontSize: 14,
    color: dark,
    fontWeight: FontWeight.normal,
  );
}