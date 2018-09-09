import 'package:flutter/material.dart';

import 'package:find_my_cube/utils/fmc_navigator.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Study Halls'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/manageStudyHalls');
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Study Halls'),
            onTap: () {
              FMCNavigator.goToStudyHallsList(context);
            },
          )
        ],
      ),
    );
  }
}
