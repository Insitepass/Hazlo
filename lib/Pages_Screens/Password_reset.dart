import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:hazlo/Services/Authentication.dart';

import 'Login.dart';




// ignore: camel_case_types
class password_reset extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _PasswordState();


  }




class _PasswordState extends State<password_reset> {
  TextEditingController _emailField;
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();


  @override
  void initState() {
    _emailField = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //TODO build password reset form and add functionlity
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Rest Password'),

        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Please enter your email address',
                      style: TextStyle(
                          color: Color(0xFF005792),
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),

                  // Email field
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) return "Email is required";
                        return null;
                      },
                      controller: _emailField,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),

                  // reset button
                  Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                       style:ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      child: Text('Send reset link'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          showAboutDialog(context);
                          try {
                            await _auth.resetPassword(_emailField.text);
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  )
                ],
              ))),
    );
  }

                     


  // message box at the end
  showAboutDialog(BuildContext context) {
    // set up the button
    TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, new MaterialPageRoute(
            builder: (context) => new Login()));
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset Link set to your email"),
      content: Text(
          "Hang tight the link is on the way!"),
      actions: [
        new TextButton(onPressed: () {
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new Login()));
        }, child: new Text("close"))
      ],
    );


    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return alert;
      },

    );
  }
}
