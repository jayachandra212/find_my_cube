import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/pages/splash/splash_screen.dart';
import 'package:find_my_cube/pages/search_screen.dart';
import 'package:find_my_cube/pages/login/auth_page.dart';
import 'package:find_my_cube/pages/signup/signup_options.dart';
import 'package:find_my_cube/pages/signup/signup_manager.dart';
import 'package:find_my_cube/pages/signup/signup_student.dart';
import 'package:find_my_cube/pages/studyhall/studyhall_list/studyhalls.dart';
import 'package:find_my_cube/pages/studyhall/studyhall_list/studyhall_info.dart';
import 'package:find_my_cube/pages/studyhall/manage/manage_studyhalls.dart';
import 'package:find_my_cube/scoped_models/main.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = new MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: new MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.greenAccent),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          "/search": (BuildContext context) => SearchScreen(),
          "/authenticate": (BuildContext context) => LoginScreen(),
          "/signUpOptions": (BuildContext context) => SignUpOptions(),
          "/signUpStudent": (BuildContext context) => SignUpStudent(),
          "/signUpManager": (BuildContext context) => SignUpManager(),
          "/studyHalls": (BuildContext context) => StudyHallsPage(model),
          "/manageStudyHalls": (BuildContext context) => ManageStudyHallsPage(model)
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'studyHall') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => StudyHallInfoPage(index));
          }
          return null;
        },
      ),
    );
  }
}

void main() => runApp(MyApp());
