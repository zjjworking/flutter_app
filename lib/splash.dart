import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tab/home.dart';
import 'package:flutter_tab/animation.dart';

class SplashPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new SplashSate();
}

class SplashSate extends State<SplashPage>{
  Timer _t;
  @override
  void initState() {
    super.initState();
    _t = new Timer(const Duration(milliseconds: 2000),(){
      try{
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
            builder: (BuildContext context) => new FlutterApp()),(
            Route route) => route == null);
      }catch (e){

      }
    });
  }
  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: new Color.fromARGB(255, 0, 215, 198),
      child: new Padding(padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: new Column(
        children: <Widget>[
          new Text("Flutter",
          style: new TextStyle(color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold),),
          new LogoApp(),
        ],
      ),),
    );
  }
}