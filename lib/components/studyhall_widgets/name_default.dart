import 'package:flutter/material.dart';

class NameDefault extends StatelessWidget {
  final String name;

  NameDefault(this.name);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      name,
      style: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
