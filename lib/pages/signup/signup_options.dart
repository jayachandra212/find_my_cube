import 'package:flutter/material.dart';

class SignUpOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up Options',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        //color: Color.fromRGBO(255,255,224, 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Text('Please Select AccountType',
            style: TextStyle(
              fontSize: 17.0
            ),),
            ListTile(
              title: Text('Student'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.pushNamed(context, "/signUpStudent");
              },
            ),
            ListTile(
              title: Text('Manager'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.pushNamed(context, "/signUpManager");
              },
            )
          ],
        ),
      ),
    );
  }
}
