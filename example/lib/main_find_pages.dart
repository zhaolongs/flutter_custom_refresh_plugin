import 'package:custom_refresh_plugin/custom_refresh_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'home_item_page4.dart';


class MainFindPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainFindPageState();
  }
}

class MainFindPageState extends State with SingleTickerProviderStateMixin {
  TabController tabController;

  List<String> topTabList = [
    "推荐",
    "动态",
    "Java",
    "程序人生",
    "移动开发",
    "数据算法",
    "程序感言",
  ];

  List<Widget> bodyPageList = [];

  CustomRefreshController customRefreshController =
      new CustomRefreshController();

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: topTabList.length, vsync: this);

    for (int i = 0; i < topTabList.length; i++) {
      bodyPageList.add(new HomeItemPage4(i, topTabList[i]));
    }

    customRefreshController.setOnRefreshListener(() {
      print("下拉刷新了");
      Future.delayed(Duration(milliseconds: 5000),(){
        customRefreshController.closeRefresh();
      });
    });
    customRefreshController.setOnLoadMoreListener(() {
      print("上拉加载刷新了");
      Future.delayed(Duration(milliseconds: 5000),(){
        customRefreshController.closeLoadMore();
      });
    });
    customRefreshController.setOnRefreshFinishListener(() {
      print("下拉刷新结束了");
    });
    customRefreshController.setOnScrollListener(
        (double scrollPixe, double totalScrollPixe, bool toDown) {
      print("滑动兼听 $scrollPixe  $toDown ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildRootLayout();
  }

  Widget buildRootLayout() {
    return Scaffold(
      ///可滑动的布局
      body: CustomRefreshPage(
        child: buildBodyFunction(),
        isRefreshLog: true,
        useShowLoadMore: true,
        customRefreshController: customRefreshController,
      ),
    );
  }

  ScrollController scrollController = new ScrollController();
  Widget buildBodyFunction() {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool flag) {
        return [
          SliverAppBar(
            ///用来设置 SliverAppBar 是否固定
            pinned: true,
            expandedHeight: 240,

            flexibleSpace: FlexibleSpaceBar(
              background: buildBannerFunction(),
            ),

            ///是否随着滑动来隐藏标题
            floating: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  print("点击了添加");
                },
              )
            ],

            /// TabBar 标签栏
            bottom: TabBar(

                /// 设置TabBar中的标签栏是否可以滑动
                ///   false 不可滑动
                isScrollable: true,

                ///控制器
                controller: tabController,

                ///标签
                tabs: topTabList
                    .map(
                      (String tabTite) => Tab(
                        text: tabTite,
                      ),
                    )
                    .toList()),
          )
        ];
      },
      body: TabBarView(
        children: bodyPageList,
        controller: tabController,
      ),
    );
  }

  Future refresh() async {
    return Future.delayed(Duration(milliseconds: 3000));
  }

  List<String> imageList = [
    "http://img.51miz.com/Element/00/59/61/25/87dbe10e_E596125_03347b73.jpg%21/quality/90/unsharp/true/compress/true/format/jpg",
    "http://www.im2m.com.cn/uploads/5/image/public/201903/20190326094949_ua17d9s68p.jpg",
    "http://www.xa-industrycloud.com/u/cms/www/201712/281752047fkq.jpg",
  ];

  int bannerIndex = 0;

  Widget buildBannerFunction() {
    return Container(
        height: 200,

        ///轮播图
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Swiper(
                onIndexChanged: (value) {
                  setState(() {
                    bannerIndex = value;
                  });
                },

                ///轮播图个数
                itemCount: 3,

                ///构建子条目
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 200,
                    child: Image.network(
                      imageList[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              left: 0,
              top: 0,
              bottom: 0,
              right: 0,
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(left: 4, right: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  "${bannerIndex + 1}/3",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              bottom: 10,
              right: 20,
            )
          ],
        ));
  }
}
