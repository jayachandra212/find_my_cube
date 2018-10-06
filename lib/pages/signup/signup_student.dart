import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/components/signup_widgets/SignUpButton.dart';
import 'package:find_my_cube/components/signup_widgets/signup_student_form.dart';
import 'package:find_my_cube/scoped_models/main.dart';
import 'package:find_my_cube/utils/fmc_navigator.dart';

class SignUpStudent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpStudent();
  }
}

class _SignUpStudent extends State<SignUpStudent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();

  void _submitForm(Function SignUpStudent, Map formData) async {
    print(formData);
    Map<String, dynamic> successInformation;
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    successInformation = await SignUpStudent(
        formData['email'], formData['password'], formData['displayName']);
    print("successInformation");
    print(successInformation);
    if (successInformation['success']) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Info'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    FMCNavigator.goToLogin(context);
                  },
                )
              ],
            );
          });
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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign Up Student',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: new Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            colors: <Color>[
              const Color.fromRGBO(255, 255, 255, 0.5),
              const Color.fromRGBO(0, 0, 0, 0.3),
            ],
            stops: [0.2, 1.0],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
          )),
          child: ListView(
            children: <Widget>[
              new Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new SignUpStudentForm(
                          formKey: _formKey,
                          usernameController: usernameController,
                          passwordController: passwordController,
                          displayNameController: displayNameController,
                        ),
                        ScopedModelDescendant<MainModel>(builder:
                            (BuildContext context, Widget child,
                                MainModel model) {
                          return new Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: new InkWell(
                                child: new SignUpUser(),
                                onTap: () {
                                  final Map<String, dynamic> _formData = {
                                    'email': usernameController.text,
                                    'password': passwordController.text,
                                    'displayName': displayNameController.text
                                  };
                                  _submitForm(model.signUpStudent, _formData);
                                },
                              ));
                        }),
                      ],
                    ),
                  ]),
            ],
          ),
        ));
  }
}
