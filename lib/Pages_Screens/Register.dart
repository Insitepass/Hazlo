import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Services/Authentication.dart';
import 'Login.dart';


class Register extends StatefulWidget {
  final Function showError;

  const Register({Key key, this.showError}) : super(key: key);
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
  TextEditingController _emailField = new TextEditingController();
  TextEditingController _passwordField = new TextEditingController();
  TextEditingController _confirmPasswordField = new TextEditingController();
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
   // final user = Provider.of<AuthService>(context);
    return Scaffold(
        key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
        child:Text('Register'),
      )
      ),
      body: Padding(

        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,

          child:ListView(
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

            // Email Field
            Container(
              padding: EdgeInsets.all(10),

              child: TextFormField(
                controller: _emailField,
                validator: (val) {
                  if (val.isEmpty) return "Email is required";
                  return null;
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
                  if(val.isEmpty) return "Password is required";
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onEditingComplete: () =>
                FocusScope.of(context).requestFocus(confirmPasswordField),
              ),
            ),


            // Confirm Password field
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
             controller: _confirmPasswordField,
                focusNode: confirmPasswordField,
             // TODO add validator
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
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Color(0xFF005792),
                child: Text('Register'),
                onPressed: () async {
                  //TODO validation for confirm password and password and email
                if(_formKey.currentState.validate())
                  { if(_confirmPasswordField.text == _passwordField.text)
                           showAboutDialog(context);
                    if(!await _auth.registerWithEmailAndPassword(_emailField.text,_passwordField.text))

                     widget.showError();

                  } else {
                   widget.showError("Passsword and confirm password does not match");

                  }
                }
              ),
            ),
          ],
        ),
      ),

    ));

  }

  }
// message box at the end
showAboutDialog(BuildContext context){

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
      new FlatButton(onPressed:() { Navigator.push(context, new MaterialPageRoute(
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