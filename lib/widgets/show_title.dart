import 'package:flutter/material.dart';

class ShowTitle extends StatelessWidget {
  final String title;
  final TextStyle textStlye;
  const ShowTitle({
    Key? key,
    required this.title,
    required this.textStlye,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textStlye,
    );
  }
}
