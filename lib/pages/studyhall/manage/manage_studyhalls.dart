import 'package:flutter/material.dart';
import 'package:find_my_cube/components/studyhall_widgets/sidebar.dart';
import 'package:find_my_cube/scoped_models/main.dart';
import 'package:find_my_cube/pages/studyhall/manage/add_studyhall.dart';
import 'package:find_my_cube/pages/studyhall/manage/edit_studyhall_info.dart';

class ManageStudyHallsPage extends StatelessWidget {

  final MainModel model;

  ManageStudyHallsPage(this.model);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: SideBar(),
          appBar: AppBar(
            title: Text('Manage Study Halls'),
            bottom: TabBar(tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Register Study Hall',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Study Halls',
              )
            ]),
          ),
          body: TabBarView(children: <Widget>[
            AddStudyHallPage(),
            EditStudyHallInfoPage(model)
          ]),
        ));
  }
}
