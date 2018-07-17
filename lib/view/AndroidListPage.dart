import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tab/api/Api.dart';
import 'package:flutter_tab/util/NetUtils.dart';
import 'package:flutter_tab/constants/Constants.dart';
import 'package:flutter_tab/view/NewsDetailPage.dart';


class AndroidListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new AndroidListState();

}
class AndroidListState extends State<AndroidListPage>{
  var listData;
  var mPage = 1;

  ScrollController _controller = new ScrollController();
  TextStyle titleTextStyle = new TextStyle(fontSize: 16.0);
  TextStyle subtitleStyle = new TextStyle(color: const Color(0xFFB5BDC0), fontSize: 13.0);

  AndroidListState(){
    _controller.addListener((){
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels){
        print("load more ... ");
        mPage ++;
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
  Future<Null> _pullToRefresh() async{
    mPage = 1;
    getNewsList(false);
    return null;
  }
  @override
  Widget build(BuildContext context) {
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
    String url = Api.GANK_ANDROID+mPage.toString();
    print("newsListUrl:$url");
    NetUtils.get(url, (data){
      if(data != null){
        Map<String,dynamic> map = json.decode(data);
        var results = map['results'];
        setState(() {
          if(!isLoadMore){
            listData = results;
          }else{
            List list =new List();
            list.addAll(listData);
            list.addAll(results);
            listData = list;
          }
        });
      }
    },errorCallback: (e){
      print("get news Android list error: $e");
    });
  }

  Widget renderRow(i){
    i -= 1;
    if (i.isOdd) {
      return new Divider(height: 1.0);
    }
    i = i ~/ 2;
    var itemData = listData[i];
    var titleRow = new Row(
      children: <Widget>[
        new Expanded(
            child: new Text(itemData['desc'], style: titleTextStyle,))
      ],
    );
    String time = itemData['createdAt'];
    var timeRow = new Row(
      children: <Widget>[
        new Text(itemData['who'], style: subtitleStyle,),
        new Expanded(
            flex: 1,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(time.substring(0,10))
              ],
            ))
      ],
    );
    var thumbImgUrl = itemData['images'];
    var imgUrl = "";
    if(thumbImgUrl != null){
      imgUrl = thumbImgUrl[0];
    }
    var thumbImag = new Container(
      margin: const EdgeInsets.all(10.0),
      width: 200.0,
      height: 200.0,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFFECECEC),
        image: new DecorationImage(image:imgUrl.length > 0 ? new NetworkImage(imgUrl) :
        new ExactAssetImage('./images/ic_img_default.jpg'),fit: BoxFit.cover)
      ),
    );
    var column =  new Padding(
        padding: const EdgeInsets.all(10.0),
    child: new Column(
        children: <Widget>[
          titleRow,
          thumbImag,
          timeRow,
        ],
    ),);
    var card = new Card(
      child: column,
    );
    return new InkWell(
      child: card,
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new NewsDetailPage(id: itemData['url'])));
      },
    );
  }
}
