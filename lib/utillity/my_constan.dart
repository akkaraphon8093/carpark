import 'package:flutter/material.dart';

class MyConstant {
  
  //Genernal
  static String appName = 'CarPark';
  static String appName2 = 'CarPark';

  //Route
  static String routeAuthen = '/authen';
  static String routeCreatAccount = '/creatAccount';
  static String routeBuyerService = '/buyerService';
  static String routeTestMap = '/testMap';
  static String routeRiderService = '/riderService';
  static String routeMapUser = '/mapUser';
  static String routeLoading = '/loading';

  //Image
  static String image1= 'images/image1.png';
  static String image2= 'images/image2.png';
  static String image3= 'images/image3.png';
  static String image4= 'images/image4.png';
  static String logo= 'images/logotest.png';
  static String newlogo= 'images/newlogo.png';
  static String logotest= 'images/logobate.png';

  //color
  static Color primary = Color(0xff6381a8);
  static Color dark = Color(0xff345579);
  static Color light = Color(0xff93b0da);
  static Color oren1 = Color(0xffeda024);
  static Color bg = Color(0xff2c2c2b);

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
  TextStyle h4Style() => TextStyle(
    fontSize: 14,
    color: oren1,
    fontWeight: FontWeight.normal,
  );

  ButtonStyle myButtonStyle()=>ElevatedButton.styleFrom(
              primary: MyConstant.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            );
}