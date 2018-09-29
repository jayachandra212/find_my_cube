import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/pages/studyhall/manage/add_studyhall.dart';
import 'package:find_my_cube/scoped_models/main.dart';

class EditStudyHallInfoPage extends StatefulWidget {
  final MainModel model;

  EditStudyHallInfoPage(this.model);

  State<StatefulWidget> createState() {
    return _EditStudyHallInfoPageState();
  }
}

class _EditStudyHallInfoPageState extends State<EditStudyHallInfoPage> {

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.selectStudyHall(model.allStudyHalls[index].id);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return AddStudyHallPage();
              },
            ),
          ).then((_) {
            model.selectStudyHall(null);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    @override
    initState() {
      widget.model.fetchStudyHalls();
      super.initState();
    }
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key(model.allStudyHalls[index].name),
                  background: Container(color: Colors.red,),
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.endToStart) {
                      print('Swipe end to start');
                      model.selectStudyHall(model.allStudyHalls[index].id);
                      model.deleteStudyHall();
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                model.allStudyHalls[index].image)),
                        title: Text(model.allStudyHalls[index].name),
                        subtitle: Text(
                            '\$${model.allStudyHalls[index].price
                                .toString()}'),
                        trailing: _buildEditButton(context, index, model),
                      ),
                      Divider()
                    ],
                  ));
            },
            itemCount: model.allStudyHalls.length,
          );
        });
  }
}
