import 'package:flutter/material.dart';
import 'package:carpark/utillity/my_constan.dart';
import 'package:carpark/widgets/show_image.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(children: <Widget>[
        Container(
          width: 100,
        ),
        Expanded(
          child: TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeAuthen),
            child: ShowImage(path: MyConstant.logotest),
          ),
          flex: 2,
        ),
        Expanded(
          child: Align(
            
          ),
          flex: 1,
        )
      ])),
    );
  }
}
