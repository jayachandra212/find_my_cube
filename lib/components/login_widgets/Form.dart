import 'package:flutter/material.dart';
import 'package:find_my_cube/components/login_widgets/InputFields.dart';

class FormContainer extends StatelessWidget {

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final GlobalKey formKey;

  FormContainer({this.formKey,this.usernameController,this.passwordController});

  String _validateUsername(String value) {
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Please enter valid email address';
    }
   return null;
  }

  String _validatePassword(String value) {
    if (value == null || value.isEmpty)
      return 'Please enter a Password';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new Form(
       key: formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new InputFieldArea(
                hint: "Username",
                obscure: false,
                icon: Icons.person_outline,
                controllerName: usernameController,
                formFieldValidator: _validateUsername,
              ),
              new InputFieldArea(
                hint: "Password",
                obscure: true,
                icon: Icons.lock_outline,
                controllerName: passwordController,
                formFieldValidator: _validatePassword,
              ),
            ],
          )
      ),
    ));
  }
}
