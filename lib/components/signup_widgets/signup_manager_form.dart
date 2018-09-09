import 'package:flutter/material.dart';

class SignUpManagerForm extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Form(
      child: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextFormField(
              decoration: new InputDecoration(
                hintText: "Name",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextFormField(
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                hintText: "Phone",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.calendar_today),
            title: new TextFormField(
              decoration: new InputDecoration(
                hintText: "Date of Birth (DD/MM/YYYY)",
              ),
              keyboardType: TextInputType.datetime,
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