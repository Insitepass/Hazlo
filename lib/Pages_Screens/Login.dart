
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:hazlo/Pages_Screens/Register.dart';
import 'package:hazlo/Services/Authentication.dart';
import 'NoteList.dart';




class Login extends StatefulWidget {
  final Function showError;

  const Login({Key key, this.showError}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode passwordField = FocusNode();
  final AuthService _auth = AuthService();



  TextEditingController _emailField;
  TextEditingController _passwordField;

   //text field state
  //String _emailField = '';
  //String _passwordField = '';
 // String _error = '';

  @override
   void initState() {

    _emailField = TextEditingController();
    _passwordField = TextEditingController();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
  //final user = Provider.of<AuthService>(context, listen: false);

    return Scaffold(

        appBar: AppBar(
          title: Center(
         child: Text('Login'),
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

                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (val) {
                      if(val.isEmpty) return "Email is required";
                      return null;
                    },
                    controller: _emailField,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordField);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    validator: (val) {
                      if(val.isEmpty) return "Password is required";
                      return null;
                    },
                    controller: _passwordField,
                    obscureText: true, // this one makes password not visible
                    focusNode: passwordField,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),

                  ),
                ),
                FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  textColor: Color(0xFF005792),
                  child: Text('Forgot Password'),
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Color(0xFF005792),
                      child: Text('Login'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new NoteList()));
                          if (!await _auth.signInWithEmailAndPassword(_emailField.text, _passwordField.text))
                          widget.showError();
                        } else {

                          //TODO add else statement maybe dialog

                        }
                      }

                        ),
                     ),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Color(0xFF005792),
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => new Register()
                            ));
                          },
                        ),
                       // user.Status = Status.Authenticating,

                      ],
                    ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
               child:OutlineButton(
                 splashColor: Color(0xFF005792),
                 onPressed: () async {
                   if(!await _auth.signInWithGoogle())
                    print('Some thing went wrong');
                   else {
                     Navigator.push(context, new MaterialPageRoute(
                         builder: (context) => new NoteList()));
                   }
               },
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                 highlightElevation: 0,
                 borderSide: BorderSide(color: Colors.grey),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Image(image: AssetImage("assets/img/google_logo.png"), height: 35.0),
                       Padding(
                         padding: const EdgeInsets.only(left: 10),
                         child: Text(
                           'Sign in with Google',
                           style: TextStyle(
                             fontSize: 20,
                             color: Colors.grey,
                           ),
                         ),
                       )
                     ],
                   ),
                 ),
               )
                ),
              ],
            ))));
  }
}

