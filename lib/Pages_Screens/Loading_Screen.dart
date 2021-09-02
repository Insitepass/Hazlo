import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Widget/BottomNavigator.dart';

class LoadScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoadScreenState();
  }
  
  
}

class LoadScreenState extends State<LoadScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => new BottomNavbar())));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset('assets/img/icon_logo_hazlo.png'),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
            ),
            CircularProgressIndicator()
          ],


        ),




      ),

    );
  }
}
