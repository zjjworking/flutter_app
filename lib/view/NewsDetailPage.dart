import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsDetailPage extends StatefulWidget {
  final String id;

  /**
   * 尽可能使用const修饰控件，这相当于缓存一个控件，并重新使用它
   */
  const NewsDetailPage({Key key, this.id})
      : assert(id != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => new NewsDetailPageSate();
}

class NewsDetailPageSate extends State<NewsDetailPage> {
  bool loaded = false;
  String detailDataStr;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    //监听webview的加载事件
    flutterWebViewPlugin.onStateChanged.listen((state) {
      print("state: ${state.type}");
      if (state.type == WebViewState.finishLoad) {
        //加载完成
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(new Text(
      "详情资讯",
      style: new TextStyle(color: Colors.white),
    ));
    titleContent.add(new Container(
      width: 50.0,
    ));
    return new WebviewScaffold(
      url: widget.id,
      appBar: new AppBar(
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}
