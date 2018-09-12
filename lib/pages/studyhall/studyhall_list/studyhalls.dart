import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/components/studyhall_widgets/sidebar.dart';
import 'package:find_my_cube/components/studyhall_widgets/studyhalls.dart';
import 'package:find_my_cube/scoped_models/main.dart';

class StudyHallsPage extends StatefulWidget {
  final MainModel model;

  StudyHallsPage(this.model);

  State<StatefulWidget> createState() {
    return _StudyHallsPageState();
  }
}

class _StudyHallsPageState extends State<StudyHallsPage> {
  @override
  void initState() {
    widget.model.fetchStudyHalls();
    super.initState();
  }

  Widget _buildStudyHallList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No Study Halls Found !!'));
      if (model.displayedStudyHalls.length > 0 && !model.isLoading) {
        content = StudyHalls();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(onRefresh: model.fetchStudyHalls, child: content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text('Study Halls'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                  icon: Icon(model.displayFavoritesOnly
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    model.toggleDisplayMode();
                  },
                );
              },
            )
          ],
        ),
        body: _buildStudyHallList());
  }
}
