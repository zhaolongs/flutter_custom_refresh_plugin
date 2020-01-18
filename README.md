# custom_refresh_plugin
flutter NestedScrollView 下拉刷新插件


在 flutter 项目中使用
***

#### 1  添加依赖

 配制文件中 pubspec.yaml 
 
  ```
  custom_refresh_plugin:
    #git 方式依赖
    git:
      #仓库地址
      url: https://github.com/zhaolongs/flutter_custom_refresh_plugin.git
      # 分支
      ref: master
 ```
 #### 2 为 NestedScrollView 添加下拉刷新

   ```dart


  @override
  Widget build(BuildContext context) {
    return buildRootLayout();
  }

  Widget buildRootLayout() {
    return Scaffold(
      ///可滑动的布局
      body: CustomRefreshPage(
        ///子Widget
        child:NestedScrollView(
          .... 此处省略
        ),
        ///刷新控制器
        customRefreshController:customRefreshController,
      ),
    );
  }

   ```
   
   
   #### 3 为 CustomRefreshController  下拉刷新控制器
   
   ##### 3.1 创建 CustomRefreshController
   
    声明成员变量
    
 ```dart
     CustomRefreshController customRefreshController = new CustomRefreshController();
```

##### 3.2 CustomRefreshController 设置兼听

```dart

 CustomRefreshController customRefreshController = new CustomRefreshController();
  @override
  void initState() {
    super.initState();
    ///设置下拉刷新兼听
    ///本方法 是当下拉滑动到一定的距离时会触发一次
    customRefreshController.setOnRefreshListener(() {
      print("兼听到开始刷新回调");
      ///这里使用的是模拟网络加载效果
      Future.delayed(new Duration(milliseconds: 3000), () {
        ///结束刷新
        customRefreshController.closeRefresh();
        showCenterToast("已刷新");
      });
    });

    ///设置下拉滑动距离兼听
    ///[scrollPixe] 滑动距离兼听
    ///[totalScrollPixe] 总共可滑动的距离
    ///[toDown] true 向下滑动 false 向上滑动
    customRefreshController.setOnScrollListener(
      (double scrollPixe, double totalScrollPixe, bool toDown) {
        
      },
    );
    ///下拉刷新圆圈消失的回调方法
    customRefreshController.setOnRefreshFinishListener((){
      
    });
    
    
  }
```