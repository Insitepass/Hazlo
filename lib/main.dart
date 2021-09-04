import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hazlo/Pages_Screens/Splashscreen.dart';
import 'package:hazlo/Services/admob_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adHelper =AdHelper(initFuture);
  runApp(
      Provider.value(
        value:adHelper,
        builder:(context,child) => MyApp(),
      )
  );

}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

Map<int,Color>color = {

  50:Color.fromRGBO(0, 87, 146, .1),
  100:Color.fromRGBO(0, 87, 146, .2),
  200:Color.fromRGBO(0, 87, 146, .3),
  300:Color.fromRGBO(0, 87, 146, .4),
  400:Color.fromRGBO(0, 87, 146, .5),
  500:Color.fromRGBO(0, 87, 146, .6),
  600:Color.fromRGBO(0, 87, 146, .7),
  700:Color.fromRGBO(0, 87, 146, .8),
  800:Color.fromRGBO(0, 87, 146, .9),
  900:Color.fromRGBO(0, 87, 146, 1),


};

MaterialColor colorCustom =  MaterialColor(0xFF005792, color);

class MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hazlo',
      theme:
      ThemeData(
        //   // This is the theme of your application.
        //   //
        //   // Try running your application with "flutter run". You'll see the
        //   // application has a blue toolbar. Then, without quitting the app, try
        //   // changing the primarySwatch below to Colors.green and then invoke
        //   // "hot reload" (press "r" in the console where you ran "flutter run",
        //   // or simply save your changes to "hot reload" in a Flutter IDE).
        //   // Notice that the counter didn't reset back to zero; the application
        //   // is not restarted.
        //
        //   // this is a custom color
        primarySwatch: colorCustom,
        //   // This makes the visual density adapt to the platform that you run
        //   // the app on. For desktop platforms, the controls will be smaller and
        //   // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
      Splashscreen(),
    );
  }

}


