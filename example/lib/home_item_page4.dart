import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeItemPage4 extends StatefulWidget {
  num pageIndex;
  String pageTitle;

  HomeItemPage4(this.pageIndex,
      this.pageTitle,);

  @override
  State<StatefulWidget> createState() {
    return HomeItemPageState();
  }
}

class HomeItemPageState extends State<HomeItemPage4> {


  ScrollController scrollController = new ScrollController();
  ScrollController scrollController2 = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///创建列表
    return Container(
      color: Colors.grey[100],
      child: buildListView(),);
  }

  Widget buildListView() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 8),
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 130,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 2),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "这里是标题",
                  style:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "山高水长,执剑天涯，从你的点滴积累开始，所及之处，必精益求精，即是折腾每一天",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "早起的年轻人",
                      style:
                      TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(
                      Icons.thumb_up,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "20",
                      style:
                      TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    SizedBox(
                      width: 26,
                    ),
                    Icon(
                      Icons.share,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "120",
                      style:
                      TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

//
}
