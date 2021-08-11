import 'package:carpark/utillity/my_constan.dart';
import 'package:carpark/widgets/show_image.dart';
import 'package:flutter/material.dart';

class RiderService extends StatefulWidget {
  const RiderService({ Key? key }) : super(key: key);

  @override
  _RiderServiceState createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TextButton(onPressed: () =>Navigator.pushNamed(context, MyConstant.routeMapUser), child: ShowImage(path: MyConstant.image4)),)
      
      
    );
  }
}
