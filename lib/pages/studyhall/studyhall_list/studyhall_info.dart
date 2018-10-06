import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:find_my_cube/components/studyhall_widgets/name_default.dart';
import 'package:find_my_cube/scoped_models/main.dart';
import 'package:find_my_cube/models/studyhall.dart';

class StudyHallInfoPage extends StatelessWidget {
  final StudyHall studyHall;

  StudyHallInfoPage(this.studyHall);

  Widget _buildAddressPriceRow(double price, String location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(location),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0), child: Text('|')),
        Text('\$' + price.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return WillPopScope(
            onWillPop: () {
              Navigator.pop(context, false);
              model.selectStudyHall(null);
              return Future.value(false);
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(studyHall.name),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeInImage(
                      image: NetworkImage(studyHall.image),
                      height: 300.0,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/fmc_logo.png'),
                    ),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: NameDefault(studyHall.name)),
                    _buildAddressPriceRow(studyHall.price, studyHall.location)
                  ],
                )));
      },
    );
  }
}
