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

class LoadScreenState extends State<LoadScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;


  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => new BottomNavbar())));


    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child:Image.asset('assets/img/icon_logo_hazlo.png'),
            )

          ],


        ),


      ),

    );
  }

}
