import 'package:flutter/material.dart';

class SigninLogo extends StatelessWidget {
  final DecorationImage image;
  SigninLogo({this.image});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: 250.0,
      height: 250.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: image,
      ),
    ));
  }
}
