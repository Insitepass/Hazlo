
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hazlo/Pages_Screens/NoteList.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Widget/Theme.dart';
import 'package:provider/provider.dart';

import 'Login.dart';




class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return SettingsPage();
  }
  
}

class SettingsPage extends StatefulWidget {

const SettingsPage({
  Key key, theme, MaterialApp Function( BuildContext context, ThemeData) builder,
}) : super(key:key);

  @override
  SettingsPageState createState() => SettingsPageState();

}


//dark theme
ThemeData darkTheme = ThemeData(
    accentColor: Colors.blueGrey,
    brightness: Brightness.dark,
    primaryColor: Colors.white
);

// normal theme
ThemeData lightTheme = ThemeData(
  accentColor:  Colors.blueGrey,
  brightness: Brightness.light,
  primaryColor: Color(0xFF005792)
);

class SettingsPageState extends State<SettingsPage> {

  String _emailField;
  String _passwordField;
  bool yes = true;
  bool darkThemeEnabled = false;
  bool lightThemeEnabled = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
   String collection;
   String id;


  bool value = true;




  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _firebaseAuth.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //theme: darkThemeEnabled ? darkTheme : lightTheme,
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                  "Settings"
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => NoteList()));
                },
              ),
            ),

            body: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                // Account Card
                Text("Account",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),

                Center(
                  child: Card(
                      elevation: 4.0,
                      child: Column(
                          children: <Widget>[
                            //Displaying name
                            ListTile(
                              leading: Icon(Icons.person,
                                  color: Colors.blueGrey,
                                  size: 35.0
                              ),
                              title: Text("${user?.displayName}"),
                              //subtitle:Text("${user?.displayName}") ,
                            ),
                            // Display email
                            ListTile(
                              leading: Icon(Icons.email,
                                  color: Colors.blueGrey,
                                  size: 35.0
                              ),
                              title: Text("${user?.email}"),
                            ),
                            Divider(
                                color: Color(0xFF005792), thickness: 1
                            ),

                            // Delete Account button
                            ListTile(
                              //TODO Delete your whole account or all the collections under your uid
                              leading: Icon(Icons.delete_forever,
                                  color: Colors.blueGrey,
                                  size: 36.0),
                              onTap: () => showAboutDialog(context),
                              title: Text("Delete Account"),
                            ),
                          ]
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Display",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Card(
                    elevation: 4.0,
                    child: Column(
                      children: <Widget>[
                        //Displaying name
                        ListTile(
                          title: Text("Dark Mode"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Dark mode toggle switch
                              Consumer<ThemeProvider>(
                                builder: (context,provider,child) =>
                               CustomSwitch(
                                  activeColor: Colors.blueGrey,
                                  value: provider.darkThemeEnabled,
                                  onChanged: (state) {
                                   provider.changeTheme();
                                  }),
                              ),
                            ],
                          ),
                        ),
                        //TODO turn off noticications
                        ListTile(
                          title: Text("Notifications"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Notifications toggle switch
                              CustomSwitch(
                                  activeColor: Colors.blueGrey,
                                  value: value,
                                  onChanged: (value) {}),
                            ],
                          ),
                        ),

                      ],
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "More",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Card(
                    elevation: 4.0,
                    child: Column(
                        children: <Widget>[
                          //Displaying name
                          ListTile(
                            title: Text("Rate Us"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //Rate us with the link to google play
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          // Terms and conditions
                          ListTile(
                            leading:Text("Terms and Conditions"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //Rate us with the link to google play
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                   //TODO create Terms and Conditons page
                                  },
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text("About"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //Rate us with the link to google play
                                Text('version'

                                ),
                              ],
                            ),
                          )
                        ]
                    )
                )

              ],
            )
        )
    );
  }




    // confirm account delete dialog
    showAboutDialog(BuildContext context) {
      FlatButton(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                child: Text('Yes'),
                onPressed: () {

                },
              ),
              RaisedButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context,false)


              ),
            ]
        ),
        onPressed: () {},
      );


      AlertDialog alert = AlertDialog(
        title: Text("Delete Account?"),
        content: Text("Are you sure you want to delete your account?"),
        actions: [
          new FlatButton (

              onPressed: () async {
                if (yes == true) {
                  await DatabaseService(collection).deleteAccount(id);
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => new Login()));
                }
                else {
                  print("Sorry an error occurred");
                }
              },
              child: new Text("Yes")
          ),

          new FlatButton(onPressed: () => Navigator.pop(context,false), child: Text("No"))
        ],
      );


      showDialog(context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return alert;
        },

      );
    }
  }


