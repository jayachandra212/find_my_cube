import 'package:flutter/material.dart';

class SignUpStudentForm extends StatelessWidget{

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController displayNameController;
  final GlobalKey formKey;

  SignUpStudentForm({this.formKey,this.usernameController,this.passwordController,this.displayNameController});

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
    else if(value.length < 6)
      return 'Password must be more than 6 charecters';
    return null;
  }

  String _validateName(String value) {
    if (value == null || value.isEmpty)
      return 'Please enter a Name';
    return null;
  }


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Form(
      key: formKey,
      child: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextFormField(
              obscureText: false,
              decoration: new InputDecoration(
                hintText: "Name",
              ),
              validator: _validateName,
              controller: displayNameController,
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextFormField(
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                hintText: "Email",
              ),
              validator: _validateUsername,
              controller: usernameController,
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.lock),
            title: new TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: new InputDecoration(
                hintText: "Password",
              ),
              validator: _validatePassword,
              controller: passwordController,
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.lock),
            title: new TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: new InputDecoration(
                hintText: "Repeat Password",
              ),
              validator: (String value){
                if (passwordController.text != value) {
                  return 'Passwords did not match';
                }
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}