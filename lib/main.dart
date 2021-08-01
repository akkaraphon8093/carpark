import 'package:carpark/states/authen.dart';
import 'package:carpark/states/buyer_service.dart';
import 'package:carpark/states/create_account.dart';
import 'package:carpark/states/rider_service.dart';
import 'package:carpark/states/saler_service.dart';
import 'package:carpark/utillity/my_constan.dart';
import 'package:flutter/material.dart';

final Map<String,WidgetBuilder>map ={
  '/authen':(BuildContext context)=>Authen(),
  '/creatAccount':(BuildContext context)=> CreatAccount(),
  'buyerService':(BuildContext context)=>BuyerService(),
  'salerService':(BuildContext context)=>SalerService(),
  'riderService':(BuildContext context)=>RiderService(),
};

String? initlaRouter;

void main(){
  initlaRouter = MyConstant.routeAuthen;
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
