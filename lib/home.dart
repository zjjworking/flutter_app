import 'package:flutter/material.dart';
import 'package:flutter_tab/Post.dart';
import 'package:flutter_tab/component/icon_tab.dart';
import 'package:flutter_tab/view/MyDrawer.dart';
import 'package:flutter_tab/view/jobs_view.dart';
import 'package:flutter_tab/view/AndroidListPage.dart';
const double _kTabTextSize = 11.0;
const int INDEX_JOB = 0;
const int INDEX_COMPANY = 1;
const int INDEX_MESSAGE = 2;
const int INDEX_MINE = 3;
Color _kPrimaryColor = new Color.fromARGB(255, 0, 215, 198);

class FlutterApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new HomeSate();
}
class HomeSate extends State<FlutterApp> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;
  TabController _controller;
  VoidCallback onChanged;
  var appBarTitles = ['资讯', 'Android', '发现', '我的'];
  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(initialIndex: _currentIndex ,length: 4, vsync: this);
    onChanged = (){
      setState(() {
        _currentIndex = this._controller.index;
      });
    };
    _controller.addListener(onChanged);
  }
  @override
  void dispose() {
    _controller.removeListener(onChanged);
    _controller.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: new Color.fromARGB(255,242,242,245),
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(appBarTitles[_currentIndex],style: new TextStyle(fontSize: 20.0,color: Colors.white)),
      ),
      body: new TabBarView(
          children: <Widget>[
            new NewsListPage(),new AndroidListPage(),new MyApp(),new MyApp()
          ],
      controller: _controller,
      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        child: new TabBar(
          controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: new TextStyle(fontSize: _kTabTextSize),
            tabs: <IconTab>[
              new IconTab(
                icon: _currentIndex == INDEX_JOB ? "images/ic_main_tab_company_pre.png": "images/ic_main_tab_company_nor.png",
                text: appBarTitles[0],
                color: _currentIndex == INDEX_JOB ? _kPrimaryColor : Colors.grey[900],
              ),
              new IconTab(
                icon: _currentIndex == INDEX_COMPANY ? "images/ic_main_tab_contacts_pre.png": "images/ic_main_tab_contacts_nor.png",
                text: appBarTitles[1],
                color: _currentIndex == INDEX_COMPANY ? _kPrimaryColor : Colors.grey[900],
              ),
              new IconTab(
                icon: _currentIndex == INDEX_MESSAGE ? "images/ic_main_tab_find_pre.png": "images/ic_main_tab_find_nor.png",
                text: appBarTitles[2],
                color: _currentIndex == INDEX_MESSAGE ? _kPrimaryColor : Colors.grey[900],
              ),
              new IconTab(
                icon: _currentIndex == INDEX_MINE ? "images/ic_main_tab_my_pre.png": "images/ic_main_tab_my_nor.png",
                text: appBarTitles[3],
                color: _currentIndex == INDEX_MINE ? _kPrimaryColor : Colors.grey[900],
              ),
            ]),
      ),
      drawer: new MyDrawer(),
    );
  }
}
void main() {
  runApp(new MaterialApp(
      title: "Flutter",
      theme: new ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: _kPrimaryColor,
        accentColor: Colors.cyan[300],
      ),
      home: new FlutterApp()));
}