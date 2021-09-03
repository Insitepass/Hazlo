
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:hazlo/Pages_Screens/Loading_Screen.dart';
import 'package:hazlo/Pages_Screens/Register.dart';
import 'package:hazlo/Pages_Screens/Password_reset.dart';
import 'package:hazlo/Services/Authentication.dart';
import 'package:connectivity/connectivity.dart';





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




  @override
  void initState() {

    _emailField = TextEditingController();
    _passwordField = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text('Login'),
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
                          'Hazlo',
                          style: TextStyle(
                              color: Color(0xFF005792),
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),

                    // Email field
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
                    // Password Field
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
                    TextButton(
                      onPressed: (){
                        Navigator.push(context,new MaterialPageRoute(builder: (context) => new password_reset()));
                      },
                      child: Text('Forgot Password'),
                    ),

                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)), ),
                          child: Text('Login'),
                          onPressed: () async {

                            try {
                              var connectivityResult = await (Connectivity().checkConnectivity());
                              if (_formKey.currentState.validate()) {
                                final user = await _auth
                                    .signInWithEmailAndPassword(_emailField.text,
                                    _passwordField.text);

                                if (user != null)
                                {
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => new LoadScreen()));
                                }

                              } else {
                                final user = await _auth
                                    .signInWithEmailAndPassword(_emailField.text,
                                    _passwordField.text);
                                if (user == null) {
                                  setState(() =>
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(' could not sign in with those credentials'),
                                          duration: Duration(seconds:2)
                                      )
                                      ));
                                  showAlertDialog(context);
                                }
                                // check connection
                                if(connectivityResult == ConnectivityResult.mobile) {
                                  return true;

                                } else if (connectivityResult == ConnectivityResult.wifi) {
                                  return true;
                                }
                                return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('No internet connection'),
                                    duration: Duration(seconds:2)
                                ));

                              }
                            }
                            catch (e)
                            {
                              print(e.toString());
                            }
                          }

                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text('Don t not have account?'),
                          TextButton(
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
                        child:OutlinedButton(
                          // splashColor: Color(0xFF005792),
                          onPressed: () async {

                            try {
                              var connectivityResult = await (Connectivity().checkConnectivity());

                              if (!await _auth.signInWithGoogle()) {
                                showAlertDialog(context);
                              }
                              // print('Some thing went wrong');
                              else {
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => new LoadScreen()));
                              }

                              // check connection
                              if(connectivityResult == ConnectivityResult.mobile) {
                                return true;

                              } else if (connectivityResult == ConnectivityResult.wifi) {
                                return true;
                              }
                               return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                 content: Text('No internet connection'),
                                 duration: Duration(seconds:2)
                               ));


                            }
                            catch (e) {
                              showAlertDialog(context);
                              print(e.toString());
                            }
                          }
                          ,
                          style: OutlinedButton.styleFrom(shape: new  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),
                            //TODO add hover with the custom color
                          ),
                              side : BorderSide(
                                  color: Colors.grey
                              )

                          ),

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






showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context,false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Something Went Wrong",
        style: TextStyle(fontSize: 16)),
    content: Text("Unable to sign in, try again later"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}





