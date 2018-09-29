import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'dart:io';

import 'package:find_my_cube/utils/styles.dart';
import 'loginAnimation.dart';
import 'package:find_my_cube/components/signup_widgets/SignUpLink.dart';
import 'package:find_my_cube/components/login_widgets/Form.dart';
import 'package:find_my_cube/components/login_widgets/SignInButton.dart';
import 'package:find_my_cube/components/login_widgets/SignInLogo.dart';
import 'package:find_my_cube/scoped_models/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Are you sure?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _submitForm(Function authenticate, String email, String password) async {
    Map<String, dynamic> successInformation;
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    successInformation = await authenticate(email,password);

    if (successInformation['success']) {
      setState(() {
        animationStatus = 1;
      });
      //Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Occured!'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(255, 255, 255, 0.5),
                      const Color.fromRGBO(0, 0, 0, 0.8),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
                  child: new ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new SigninLogo(image: fmcLogo),
                              new FormContainer(formKey:_formKey,usernameController: usernameController ,passwordController: passwordController,),
                              new SignUp()
                            ],
                          ),
                          ScopedModelDescendant<MainModel>(
                            builder: (BuildContext context, Widget child, MainModel model){
                              return animationStatus == 0
                                  ? new Padding(
                                padding: const EdgeInsets.only(bottom: 50.0),
                                child: new InkWell(
                                    onTap: () {
                                      print(usernameController.text);
                                      print(passwordController.text);
                                      print(usernameController.text == 'admin' && passwordController.text == 'admin');
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        _submitForm(model.authenticate,usernameController.text, passwordController.text);
                                        _playAnimation();
                                      }
                                    },
                                    child: new SignIn()),
                              )
                                  : new StaggerAnimation(
                                buttonController: _loginButtonController.view,
                              );
                            }
                          ),

                        ],
                      ),
                    ],
                  ))),
        )));
  }
}
