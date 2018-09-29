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
import 'package:find_my_cube/models/studyhall.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = new MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated){
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: new MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.greenAccent,
            primaryTextTheme: Theme
                .of(context)
                .primaryTextTheme
                .apply(bodyColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          "/search": (BuildContext context) => !_isAuthenticated ? LoginScreen():SearchScreen(),
          "/authenticate": (BuildContext context) => !_isAuthenticated ? LoginScreen():StudyHallsPage(_model),
          "/signUpOptions": (BuildContext context) => SignUpOptions(),
          "/signUpStudent": (BuildContext context) => SignUpStudent(),
          "/signUpManager": (BuildContext context) => SignUpManager(),
          "/studyHalls": (BuildContext context) => !_isAuthenticated ? LoginScreen():StudyHallsPage(_model),
          "/manageStudyHalls": (BuildContext context) => !_isAuthenticated ? LoginScreen():ManageStudyHallsPage(_model)
        },
        onGenerateRoute: (RouteSettings settings) {
          if(!_isAuthenticated){
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    LoginScreen());
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'studyHall') {
            final String studyHallId = pathElements[2];
            final StudyHall studyHall = _model.allStudyHalls.firstWhere((StudyHall studyHall){
              return studyHall.id == studyHallId;
            });
            _model.selectStudyHall(studyHallId);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => !_isAuthenticated ? LoginScreen():StudyHallInfoPage(studyHall));
          }
          return null;
        },
      ),
    );
  }
}

void main() => runApp(MyApp());
