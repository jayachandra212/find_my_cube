import 'package:flutter/material.dart';

class SignUpManagerForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController displayNameController;
  final TextEditingController studyHallNameController;
  final TextEditingController studyHallAddressController;
  final TextEditingController studyHallPriceController;

  final GlobalKey formKey;

  SignUpManagerForm(
      {this.formKey,
      this.usernameController,
      this.passwordController,
      this.displayNameController,
      this.studyHallNameController,
      this.studyHallAddressController,
      this.studyHallPriceController});

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
    else if (value.length < 6) return 'Password must be more than 6 charecters';
    return null;
  }

  String _validateName(String value) {
    if (value == null || value.isEmpty) return 'Please enter a Name';
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
                validator: (String value) {
                  if (passwordController.text != value) {
                    return 'Passwords did not match';
                  }
                }),
          ),
          new ListTile(
            leading: const Icon(Icons.business_center),
            title: new TextFormField(
              keyboardType: TextInputType.text,
              obscureText: false,
              decoration: new InputDecoration(
                hintText: "Study Hall Name",
              ),
              validator: _validateName,
              controller: studyHallNameController,
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.add_location),
            title: new TextFormField(
              keyboardType: TextInputType.text,
              obscureText: false,
              decoration: new InputDecoration(
                hintText: "Study Hall Address",
              ),
              validator: _validateName,
              controller:  studyHallAddressController,
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.attach_money),
            title: new TextFormField(
              keyboardType: TextInputType.number,
              obscureText: false,
              decoration: new InputDecoration(
                hintText: "Study Hall Price",
              ),
              validator: _validateName,
              controller: studyHallPriceController,
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
