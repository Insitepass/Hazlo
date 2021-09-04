
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hazlo/Pages_Screens/Feedback.dart';
import 'package:hazlo/Pages_Screens/Terms_conditions.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Services/local_Notification_Service.dart';
import 'package:package_info/package_info.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../main.dart';
import 'Login.dart';
import 'NoteList2.dart';




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

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  String _emailField;
  String _passwordField;
  bool yes = true;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  String collection;
  String id;
  String  _userName;

  bool value = true;

  @override
  void initState() {
    super.initState();
    initUser();
    _getUserName();
    _showUserName();

    _rateMyApp.init().then((_) {
      if(_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showStarRateDialog(
          context,
          title: " Enjoying the App?",
          message: 'Please leave a rating',
          actionsBuilder: (_,stars) {
            return [
              TextButton(
                child:Text('OK'),
                onPressed: () async {
                  print('Thank you for the ' + (stars == null ? '0' : stars.round().toString()) + 'star(s) !');
                  if(stars !=null && (stars == 4 || stars == 5)) {
                    // redirect user to play store to enter reviews
                  }
                  else {
                    // redirect to feedback page
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => new FeedbackPage()));
                  }
                  await _rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                },
              ),
            ];
          },
          // ignoreNativeDialog: Platform.isAndroid,
          dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom:20)
          ),
          starRatingOptions: StarRatingOptions(),
          onDismissed: () => _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }

    });
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
            key:_globalKey,
            appBar: AppBar(
              backgroundColor: colorCustom,
              title: Text(
                  "Settings"
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => NoteList2()));
                },
              ),
            ),

            body: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                FutureBuilder(
                    future:PackageInfo.fromPlatform(),
                    builder:(BuildContext context,
                        AsyncSnapshot<PackageInfo> snapshot) {
                      if(snapshot.hasData)
                        return
                          Padding(
                              padding: const EdgeInsets.only(left:8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Padding(padding: EdgeInsets.all(16.0),
                                    child: Text("Account",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
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
                                                  title: _showUserName()
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
                                          // remove ads
                                          ListTile(
                                            title: Text('Remove Ads'),
                                            trailing:Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    // TODO remove ads
                                                      onTap: () {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text('Service currently unavailable.')
                                                        ));
                                                      },
                                                      child: Image (
                                                          image: AssetImage("assets/img/noad.png"), height: 30.0)
                                                  )
                                                ]
                                            ),
                                          ),

                                          //TODO add dark mode toggle switch in the future here



                                          // stop receiving notifications
                                          ListTile(
                                            title: Text("Notifications"),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                //Notifications toggle switch
                                                CustomSwitch(
                                                    activeColor: Colors.blueGrey,
                                                    value: value,
                                                    onChanged: (value) {
                                                      _cancelAllNotifications();
                                                    }),
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
                                              title: Text("FeedBack"),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  //feedback page
                                                  IconButton(
                                                      icon: Icon(Icons.arrow_forward_ios),
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return
                                                                FeedbackPage();
                                                              // _rateMyApp;
                                                            },
                                                          ),
                                                        );
                                                      }
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
                                                  //Terms and Conditions
                                                  IconButton(
                                                    icon: Icon(Icons.arrow_forward_ios),
                                                    onPressed: () {
                                                      Navigator.push(context, new MaterialPageRoute(
                                                          builder: (context) => new TermsandConditionsPage()));
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
                                                  //version
                                                  Text(snapshot.data.version

                                                  ),
                                                ],
                                              ),
                                            )
                                          ]
                                      )
                                  ),

                                ],
                              )
                          );

                      return Container();
                    }
                ),
                // Account Card
              ],
            )
        )
    );
  }


  Future<void>_getUserName() async {
    Firestore.instance.collection('users')
        .document((await FirebaseAuth.instance.currentUser())
        .uid)
        .get()
        .then((value) {
      setState(() {
        _userName = value.data['name'].toString();
      });
    });

  }
  // showing the username method.
  _showUserName(){
    if(
    _userName == null) {
      return Text("${user?.displayName}");
    }
    else if(
    user.displayName == null)
      return Text('$_userName');
  }



  // confirm account delete dialog
  showAboutDialog(BuildContext context) {

    TextButton(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () {
                //   AuthService.reauthCurrentUser();
                // DatabaseService(id).deleteAccount(id);
                return Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new Login()));

              },
            ),
            ElevatedButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                }
            ),
          ]
      ),
      onPressed: () {},
    );


    AlertDialog alert = AlertDialog(
      title: Text("Delete Account?"),
      content: Text("Are you sure you want to delete your account?"),
      actions: [
        new TextButton (

            onPressed: () async {
              if (yes == true) {
                await DatabaseService(collection).deleteuserAuth();
                return Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new Login()));
              }
              else {
                print("Sorry an error occurred");
              }
            },
            child: new Text("Yes")
        ),

        new TextButton(onPressed: () =>  Navigator.of(context, rootNavigator:true).pop(), child: Text("No"))
      ],
    );


    showDialog(context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return alert;
      },

    );
  }
}

//cancel all notifications
Future<void> _cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}


// rate my app
RateMyApp _rateMyApp = RateMyApp(
  preferencesPrefix:  'rateMyApp_',
  minDays: 7,
  minLaunches: 7,
  remindDays: 7,
  remindLaunches: 5,
  // appStoreIdentifier: '',
  // googlePlayIdentifier: '',
);
