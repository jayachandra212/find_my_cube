import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/components/studyhall_widgets/price_tag.dart';
import 'package:find_my_cube/components/studyhall_widgets/name_default.dart';
import 'package:find_my_cube/components/studyhall_widgets/address_tag.dart';
import 'package:find_my_cube/models/studyhall.dart';
import 'package:find_my_cube/scoped_models/main.dart';

class StudyHallCard extends StatelessWidget {
  final StudyHall studyHall;
  final int studyHallIndex;

  StudyHallCard(this.studyHall, this.studyHallIndex);

  Widget _buildNamePriceRow() {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NameDefault(studyHall.name),
            SizedBox(
              width: 8.0,
            ),
            PriceTag(studyHall.price.toString())
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/studyHall/' + model.allStudyHalls[studyHallIndex].id),
        ),
        IconButton(
            icon: Icon(model.allStudyHalls[studyHallIndex].isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.selectStudyHall(model.allStudyHalls[studyHallIndex].id);
              model.toggleStudyHallFavoriteStatus();
            })
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(studyHall.image),
          _buildNamePriceRow(),
          AddressTag(studyHall.location),
          Text(studyHall.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
