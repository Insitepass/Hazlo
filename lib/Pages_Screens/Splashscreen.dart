import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Pages_Screens/Login.dart';
import 'dart:async';




class Splashscreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return  SplashscreenState();

  }

}


class SplashscreenState extends State<Splashscreen>{

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds:6),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute (
            builder: (BuildContext context) => Login())));

  }


  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Stack(
          alignment:Alignment.center,
          children:<Widget>[
            Image.asset('assets/img/hazlo4-removebg.png')

          ],
        ),

      ),
    );

  }
}
