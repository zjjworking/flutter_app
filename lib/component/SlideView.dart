import 'package:flutter/material.dart';
import 'package:flutter_tab/view/NewsDetailPage.dart';

class SlideView extends StatefulWidget{

  var data;

  SlideView(data){
    this.data = data;
  }

  @override
  State<StatefulWidget> createState() {
    return new SlideViewState(data);
  }
}
class SlideViewState extends State<SlideView> with SingleTickerProviderStateMixin{
  TabController tabController;
  List slideData;

  SlideViewState(data){
    this.slideData = data;
  }
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: slideData == null? 0: slideData.length, vsync: this);
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  Widget generateCard(){
    return new Card(
      color: Colors.blue[400],
      child: new Image.asset("images/ic_avatar_default.png",width: 20.0,height: 20.0,),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if(slideData != null && slideData.length > 0){
      for(var i=0;i < slideData.length; i++){
        var item = slideData[i];
        var imgUrl = item['imgUrl'];
        var title = item['title'];
        var detailUrl = item['detailUrl'];
        items.add(new GestureDetector(
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new NewsDetailPage(id: detailUrl)));
          },
          child: new Stack(
            children: <Widget>[
              new Image.network(imgUrl),
              new Container(
                width: MediaQuery.of(context).size.width,
                color: const Color(0x50000000),
                child: new Padding(padding: const EdgeInsets.all(6.0),
                  child: new Text(title,style: new TextStyle(color: Colors.white,fontSize: 15.0),),),
              )
            ],
          ),
        ));
      }
    }
    return new TabBarView(children: items,
    controller: tabController,);
  }

}