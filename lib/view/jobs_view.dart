import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tab/api/Api.dart';
import 'package:flutter_tab/util/NetUtils.dart';
import 'package:flutter_tab/constants/Constants.dart';
import 'package:flutter_tab/component/SlideView.dart';
import 'package:flutter_tab/component/CommonEndLine.dart';
import 'package:flutter_tab/view/NewsDetailPage.dart';

class NewsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewsListPageState();
}

class NewsListPageState extends State<NewsListPage> {
  var listData;
  var slideData;
  var curPage = 1;
  var listTotalSize = 0;
  ScrollController _controller = new ScrollController();
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);
  TextStyle subtitleStyle =
  new TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);

  NewsListPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        print("load more ...");
        curPage++;
        getNewsList(true);
      }
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    if(listData == null) {
      getNewsList(false);
    }
  }
  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getNewsList(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
  Widget getBody(){
    if (listData == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget listView = new ListView.builder(
        itemCount: listData.length * 2,
        itemBuilder: (context, i) => renderRow(i),
        controller: _controller,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }
  void getNewsList(bool isLoadMore) {
    String url = Api.NEWS_LIST;
    url += "?pageIndex=$curPage&pageSize=10";
    print("newsListUrl: $url");
    NetUtils.get(url, (data) {
      if (data != null) {
        print("$data");
        Map<String, dynamic> map = json.decode(data);
        if (map['code'] == 0) {
          var msg = map['msg'];
          listTotalSize = msg['news']['total'];
          var _listData = msg['news']['data'];
          var _slideData = msg['slide'];
          setState(() {
            if (!isLoadMore) {
              listData = _listData;
              slideData = _slideData;
            } else {
              List list = new List();
              list.addAll(listData);
              list.addAll(_listData);
              if (list.length >= listTotalSize) {
                list.add(Constants.END_LINE_TAG);
              }
              listData = list;

              slideData = _slideData;
            }
          });
        }
      }
    }, errorCallback: (e) {
      print("get news list error: $e");
    });
  }

  renderRow(int i) {
    if (i == 0) {
      return new Container(
        height: 180.0,
        child: new SlideView(slideData),
      );
    }
    //分割线
    i -= 1;
    if (i.isOdd) {
      return new Divider(height: 1.0);
    }
    i = i ~/ 2;

    var itemData = listData[i];
    if (itemData is String && itemData == Constants.END_LINE_TAG) {
      return new CommonEndLine();
    }
    var titleRow = new Row(
      children: <Widget>[
        new Expanded(child: new Text(itemData['title'], style: titleTextStyle,))
      ],
    );

    var timeRow = new Row(
      children: <Widget>[
        new Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFECECEC),
              image: new DecorationImage(
                  image: new NetworkImage(itemData['authorImg']),
                  fit: BoxFit.cover),
              border: new Border.all(
                  color: const Color(0xFFECECEC),
                  width: 2.0
              )
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(0.0),
          child: new Text(itemData['timeStr'], style: titleTextStyle,),
        ),
        new Expanded(
            flex: 1,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text("${itemData['commCount']}", style: subtitleStyle,),
                new Image.asset(
                    "./images/ic_comment.png", width: 16.0, height: 16.0)
              ],
            ))
      ],
    );
    var thumbImgUrl = itemData['thumb'];
    var thumbImg = new Container(
      margin: const EdgeInsets.all(10.0),
      width: 60.0,
      height: 60.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFECECEC),
          image: new DecorationImage(
              image: (thumbImgUrl != null && thumbImgUrl.length > 0)
                  ? new NetworkImage(thumbImgUrl)
                  : new ExactAssetImage('./images/ic_img_default.jpg'),
              fit: BoxFit.cover),
          border: new Border.all(
            color: const Color(0xFFECECEC),
            width: 2.0,
          )
      ),
    );
    var row = new Row(
      children: <Widget>[
        new Expanded(//作用填充
            flex: 1,
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                children: <Widget>[
                  titleRow,
                  new Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                  child: timeRow,)
                ],
              ),),
        ),
        new Padding(
            padding: const EdgeInsets.all(6.0),
        child: new Container(
          width: 100.0,
          height: 100.0,
          color: const Color(0xFFECECEC),
          child: new Center(
            child: thumbImg,
          ),

        ),)
      ],
    );
    return new InkWell(
      child: row,
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new NewsDetailPage(id: itemData['detailUrl'],)));
      },
    );
  }
}
