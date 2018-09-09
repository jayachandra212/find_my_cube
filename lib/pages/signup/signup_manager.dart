import 'package:flutter/material.dart';
import 'package:find_my_cube/components/signup_widgets/SignUpButton.dart';
import 'package:find_my_cube/components/signup_widgets/signup_manager_form.dart';

class SignUpManager extends StatelessWidget {
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
                        new SignUpManagerForm(),
                        new Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: new InkWell(
                              child: new SignUpUser(),
                              onTap: () {
                                print('Datta');
                              },
                            ))
                      ],
                    ),
                  ]),
            ],
          ),
        ));
  }
}
