import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_refresh_controller.dart';
import 'custom_refresh_state.dart';

export 'custom_refresh_controller.dart';
export 'custom_refresh_state.dart';

class CustomRefreshPage extends StatefulWidget {
  ///子控件
  Widget child;

  ///刷新控制器
  CustomRefreshController customRefreshController;

  ///是否输出日志
  bool isRefreshLog;

  ///刷新圆圈的大小
  double progressIconSize;
  Color progressColor;
  Color backgroundColor;

  CustomRefreshPage(
      {@required this.child,
      this.customRefreshController,
      this.isRefreshLog = false,
      this.progressIconSize = 28,
      this.progressColor,
      this.backgroundColor});

  @override
  State<StatefulWidget> createState() {
    return _CustomRefreshPageState();
  }
}

class _CustomRefreshPageState extends State<CustomRefreshPage> {
  CustomRefreshController customRefreshController;

  ///用于计算的最大下拉距离
  double defaultHeight = 40;

  ///当前下拉的距离
  double offestHeight = 0;

  ///当前刷新圆圈的进度
  double cirProgress = 0;

  ///当前刷新圆圈的透明度
  double offestOpacity = 0;

  ///计时时间 动画进行时间
  int animationTime = 500;

  ///上一次滑动的距离
  double preScrollPixe = 0;

  RefreshState currentRefreshState = RefreshState.normal;

  Widget buildScroll(Widget childWidget) {
    return Scrollbar(
      //进度条
      // 监听滚动通知
      child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            ///当前滑动的距离
            double scrollPixe = notification.metrics.pixels;

            ///当前可滑动的最大距离
            double totalScrollPixe = notification.metrics.maxScrollExtent;
            double extentAfter = notification.metrics.extentAfter;

            ///当前滑动的进度比
            double progress = scrollPixe / totalScrollPixe;

            ///只有是向下滑动的时候才启动下拉刷新
            if (scrollPixe < 0) {
              if (currentRefreshState == RefreshState.normal ||
                  currentRefreshState == RefreshState.todown) {
                if (scrollPixe.abs() < defaultHeight / 2) {
                  ///从0到1
                  offestOpacity = scrollPixe.abs() / (defaultHeight / 2);

                  ///进度一直可以是0
                  offestHeight = 0;
                } else {
                  ///为1
                  offestOpacity = 1.0;

                  ///进度转变
                  offestHeight = scrollPixe.abs() / 2;
                  if (offestHeight > defaultHeight) {
                    offestHeight = defaultHeight + 1;
                    if (currentRefreshState != RefreshState.refresh) {
                      currentRefreshState = RefreshState.refresh;
                      onCustomRefresh();
                    }
                  }
                }
              } else {
                offestOpacity = 1.0;
                offestHeight = defaultHeight;
              }

              ///滑动方向计算
              double flagScrollPixe = scrollPixe.abs() - preScrollPixe;

              ///保存滑动标识
              preScrollPixe = scrollPixe.abs();
              if (flagScrollPixe > 0) {
                ///向下滑动
                ///正常向下滑动
                logd("向下");

                ///设置回调
                if (widget.customRefreshController != null &&
                    widget.customRefreshController.onScrollListener != null) {
                  widget.customRefreshController
                      .onScrollListener(scrollPixe, totalScrollPixe, true);
                }
              } else {
                ///向上滑动
                logd("向上");

                ///设置回调
                if (widget.customRefreshController != null &&
                    widget.customRefreshController.onScrollListener != null) {
                  widget.customRefreshController
                      .onScrollListener(scrollPixe, totalScrollPixe, false);
                }
                if (currentRefreshState == RefreshState.refresh) {
                  offestHeight = null;
                }
              }
              if (offestHeight != null) {
                cirProgress = offestHeight / defaultHeight;
              } else {
                cirProgress = null;
              }
              setState(() {});
            }
            //重新构建
            logd(
                " scrollPixe: $scrollPixe  totalScrollPixe:$totalScrollPixe  extentAfter:$extentAfter $progress");
            return false;
          },
          child: childWidget),
    );
  }

  ///自定义下拉刷新回调
  void onCustomRefresh() {
    if (widget.customRefreshController != null &&
        widget.customRefreshController.onRefreshListener != null) {
      widget.customRefreshController.onRefreshListener();
    }
  }

  ///开始下拉刷新
  void startRefresh() {
    ///创建计时 TimerUtil
    TimerUtil timerUtil =
        new TimerUtil(mInterval: 100, mTotalTime: animationTime);

    ///设置计时回调
    timerUtil.setOnTimerTickCallback((value) {
      ///计算下拉刷新的控件的透明度
      offestOpacity = value / animationTime;

      ///透明度为1的时候开始刷新
      if (offestOpacity == 1) {
        ///更新刷新状态
        currentRefreshState = RefreshState.refresh;

        ///开始刷新时回调
        if (widget.customRefreshController != null &&
            widget.customRefreshController.onRefreshListener != null) {
          widget.customRefreshController.onRefreshListener();
        }
      }
      setState(() {});
    });

    ///开始正计时
    /// 0- 500
    timerUtil.startTimer();
  }

  ///结束下拉刷新
  void closeRefresh() {
    ///创建计时 TimerUtil
    TimerUtil timerUtil =
        new TimerUtil(mInterval: 100, mTotalTime: animationTime);

    ///设置计时回调
    timerUtil.setOnTimerTickCallback((value) {
      ///计算下拉刷新的控件的透明度
      offestOpacity = value / animationTime;

      ///透明度为0的时候刷新结束 恢复正常
      if (offestOpacity == 0) {
        ///更新刷新状态
        currentRefreshState = RefreshState.normal;

        ///刷新状态结束回调
        if (widget.customRefreshController != null &&
            widget.customRefreshController.onRefreshFinishListener != null) {
          widget.customRefreshController.onRefreshFinishListener();
        }
      }
      setState(() {});
    });

    ///开始倒计时
    /// 500 -0
    timerUtil.startCountDown();
  }

  @override
  void initState() {
    super.initState();
    if (widget.customRefreshController != null) {
      widget.customRefreshController.startRefresh = () {
        startRefresh();
      };

      widget.customRefreshController.closeRefresh = () {
        closeRefresh();
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      buildScroll(widget.child),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          child: Container(
            margin: EdgeInsets.only(top: offestOpacity * defaultHeight),
            height: widget.progressIconSize,
            width: widget.progressIconSize,
            child: Opacity(
              opacity: offestOpacity,
              child: CircularProgressIndicator(
                value: cirProgress,
                backgroundColor: widget.backgroundColor??Theme.of(context).primaryColor,
                valueColor: new AlwaysStoppedAnimation<Color>(widget.progressColor??Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  ///日志输出
  void logd(String message) {
    if (widget.isRefreshLog) {
      print("----【刷新组件】 $message");
    }
  }
}
