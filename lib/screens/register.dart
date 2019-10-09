import 'package:flutter/material.dart';
import 'package:ungrcioh/screens/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
// Explicit

// Method
  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.purple,
        ),
        labelText: 'Display Name',
        helperText: 'Type Your Name',
        hintText: 'English Onlyววว',
      ),
    );
  }

  Widget emailText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
        labelText: 'Emaill',
        helperText: 'Type Your Email',
        hintText: 'your@email.com',
      ),
    );
  }

  Widget passwordText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
        labelText: 'Display Password',
        helperText: 'Type Your Password',
        hintText: 'More 6 Charactor',
      ),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('test');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().textColor,
        title: Text('Regeister'),
        actions: <Widget>[
          registerButton(),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(50.0),
        children: <Widget>[
          nameText(),
          emailText(),
          passwordText(),
        ],
      ),
    );
  }
  
}
