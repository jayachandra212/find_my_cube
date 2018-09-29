import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:find_my_cube/scoped_models/main.dart';
import 'package:find_my_cube/components/signup_widgets/SignUpButton.dart';
import 'package:find_my_cube/components/signup_widgets/signup_manager_form.dart';
import 'package:find_my_cube/utils/fmc_navigator.dart';

class SignUpManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpManager();
  }
}

class _SignUpManager extends State<SignUpManager> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  final studyHallNameController = TextEditingController();
  final studyHallAddressController = TextEditingController();
  final studyHallPriceController = TextEditingController();

  void _submitForm(Function SignUpManager, Map formData) async {
    print(formData);
    Map<String, dynamic> successInformation;
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    successInformation = await SignUpManager(formData);
    print("successInformation");
    print(successInformation);
    if (successInformation['success'] && successInformation['message'] == "SHAS") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Info'),
              content: Text("Account Created Successfully & Study Hall added for validation"),
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
    } else if (successInformation['success'] && successInformation['message'] == "SHAF") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Info'),
              content: Text("Account Created Successfully & Study Hall addition failed"),
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
    }else {
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
            'Sign Up Manager',
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
                        new SignUpManagerForm(
                          formKey: _formKey,
                          usernameController: usernameController,
                          passwordController: passwordController,
                          displayNameController: displayNameController,
                          studyHallNameController: studyHallNameController,
                          studyHallAddressController:
                              studyHallAddressController,
                          studyHallPriceController: studyHallPriceController,
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
                                    'displayName': displayNameController.text,
                                    'studyHallName':
                                        studyHallNameController.text,
                                    'studyHallAddress':
                                        studyHallAddressController.text,
                                    'studyHallPrice':
                                        studyHallPriceController.text
                                  };
                                  _submitForm(model.signUpManager, _formData);
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
