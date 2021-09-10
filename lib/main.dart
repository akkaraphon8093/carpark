import 'package:carpark/states/authen.dart';
import 'package:carpark/states/buyer_service.dart';
import 'package:carpark/states/create_account.dart';
import 'package:carpark/states/loading.dart';
import 'package:carpark/states/map_user.dart';
import 'package:carpark/states/rider_service.dart';
import 'package:carpark/states/testmap.dart';
import 'package:carpark/utillity/my_constan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Map<String,WidgetBuilder>map ={
  '/authen':(BuildContext context)=>Authen(),
  '/creatAccount':(BuildContext context)=> CreatAccount(),
  '/buyerService':(BuildContext context)=>BuyerService(),
  '/testMap':(BuildContext context)=>TestMap(),
  '/riderService':(BuildContext context)=>RiderService(),
  '/mapUser':(BuildContext context)=>MapUser(),
  '/loading':(BuildContext context)=>Loading(),
  
};

String? initlaRouter;

void main(){
  initlaRouter = MyConstant.routeAuthen;
  WidgetsFlutterBinding();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlaRouter,
    );
  }
}
