import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Model/User.dart';
import 'package:hazlo/Services/Authentication.dart';
import 'Login.dart';


class Register extends StatefulWidget {
  final Function showError;
  final User user;


  const Register({Key key, this.showError,this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {

    return RegisterState();
  }
}

class RegisterState extends State<Register> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode passwordField = FocusNode();
  final FocusNode confirmPasswordField = FocusNode();
  final AuthService _auth = AuthService();
  final db = Firestore.instance;
  TextEditingController _nameField = new TextEditingController();
  TextEditingController _emailField = new TextEditingController();
  TextEditingController _passwordField = new TextEditingController();
  TextEditingController _confirmPasswordField = new TextEditingController();

  String confirmpass;


  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<AuthService>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text('Register'),
            )
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
                      'Hazlo',
                      style: TextStyle(
                          color: Color(0xFF005792),
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),

                //name field
                Container(
                  padding: EdgeInsets.all(10),

                  child: TextFormField(
                    controller: _nameField,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Name is required";
                      }
                      else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordField);
                    },
                  ),
                ),


                // Email Field
                Container(
                  padding: EdgeInsets.all(10),

                  child: TextFormField(
                    controller: _emailField,
                    validator: (val) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(pattern);
                      if (val.isEmpty) {
                        return "Email is required";
                      }
                      else if (!regExp.hasMatch(val)) {
                        return 'Invalid email';
                      }
                      else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordField);
                    },
                  ),
                ),

                // Password Field
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: _passwordField,
                    focusNode: passwordField,

                    validator: (val) {
                      if (val.isEmpty) {
                        return "Password is required";
                      }
                      else if (val.length < 6) {
                        return 'Password should be at least 6 characters';
                      }
                      else {
                        return null;
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(
                            confirmPasswordField),
                  ),
                ),


                // Confirm Password field
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    controller: _confirmPasswordField,
                    focusNode: confirmPasswordField,
                    validator: (confirmpassword) {
                      return confirmpassword.isEmpty
                          ? 'Please confirm password'
                          : validationEqual(
                          confirmpassword, _passwordField.text)
                          ? null
                          : 'Passwords do no match';
                    },
                    onChanged: (val) {
                      confirmpass = val;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: ' Confirm Password',
                    ),
                  ),
                ),

                // Separator container
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                ),

                // Submit button
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Color(0xFF005792),
                      child: Text('Register'),
                      onPressed: () async {
                        var user = await FirebaseAuth.instance.currentUser();
                        try {
                          if (_formKey.currentState.validate()) {
                            if (_confirmPasswordField.text ==
                                _passwordField.text)
                              if (!await _auth.registerWithEmailAndPassword(
                                  _emailField.text, _passwordField.text)) {
                                widget.showError();
                              }
                          } else {
                            print(
                                "An error occurred unable to register");
                          }
                        }
                        catch (e) {
                         createRecord();
                          print('registration successful');
                          showAboutDialog(context);
                          return false;
                        }
                      }
                  ),
                ),
              ],
            ),
          ),

        ));
  }

  // create Record
  void createRecord() async {
    var user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    await db.collection('users').document(uid).setData({
      'name' : _nameField.text,
      'email': _emailField.text,
      'password':_passwordField.text,
       'uid' : uid
    });

  }


// confirm password  validation
  bool validationEqual(String currentValue, String checkValue) {
    if (currentValue == checkValue) {
      return true;
    } else {
      return false;
    }
  }

// message box at the end
  showAboutDialog(BuildContext context) {
    // set up the button
    FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, new MaterialPageRoute(
            builder: (context) => new Login()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Register Successful!"),
      content: Text("Welcome to Hazlo, lets get it done."),
      actions: [
        new FlatButton(onPressed: () {
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new Login()));
        },
            child: new Text("Ok"))
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



