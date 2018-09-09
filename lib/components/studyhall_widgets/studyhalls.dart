import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/scoped_models/main.dart';
import 'package:find_my_cube/models/studyhall.dart';
import 'package:find_my_cube/components/studyhall_widgets/studyhall_card.dart';

class StudyHalls extends StatelessWidget {

  Widget _buildProductList(List<StudyHall> studyHalls) {
    Widget studyHallCard = Center(
      child: Text('No StudyHalls Found'),
    );
    if (studyHalls.length > 0) {
      studyHallCard = ListView.builder(
        itemBuilder: (BuildContext context,int index) => StudyHallCard(studyHalls[index],index),
        itemCount: studyHalls.length,
      );
    }else{
      studyHallCard = Container();
    }
    return studyHallCard;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child,MainModel model){
        return _buildProductList(model.displayedStudyHalls);
    },);
  }
}
