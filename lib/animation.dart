import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: new Container(
        margin: new EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: new FlutterLogo(),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => new _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = new Tween(begin: 200.0, end: 400.0).animate(controller);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  Widget build(BuildContext context) {
    return new AnimatedLogo(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class HeroScreen extends StatefulWidget {
  @override
  HeroState createState() => new HeroState();
}

class HeroState extends State<HeroScreen> with SingleTickerProviderStateMixin {
  bool _scaling = false;

  Matrix4 _transformScale = new Matrix4.identity();
  double scalePos = 1.0;

  set _scale(double value) =>
      _transformScale = new Matrix4.identity()..scale(value, value, 1.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new GestureDetector(
            onScaleStart: (details) {
              setState(() {
                _scaling = true;
              });
            },
            onScaleUpdate: (details) {
              var n = details.scale;
              setState(() {
                scalePos = n;
                _scale = n;
              });
            },
            onScaleEnd: (details) {
              setState(() {
                _scaling = false;
                _scale = scalePos < 1 ? 1.0 : scalePos;
              });
            },
            child: new Container(
                color: Colors.black26,
                child: new Transform(
                    transform: _transformScale,
                    child: new Center(
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          new Text(_scaling ? "Scaling" : "Scale me up"),
                        ]))))));
  }
}

void main() {
  runApp(new LogoApp());
}
