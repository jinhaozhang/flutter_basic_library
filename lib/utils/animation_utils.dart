import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:ui';


class AnimationUtils{
  static void addAnimation(
      GlobalKey rootGlobalKey, Widget piuWidget, Offset endOffset,
      Offset startOffset,
      {double maxWidth = 500,
        double minWidth = 90,
        int? millisecond,
        Function? doSomethingBeginCallBack,
        Function? doSomethingFinishCallBack}) {
    Function? _finishCallBack;

    //创建浮层
    OverlayEntry _overlayEntry = OverlayEntry(builder: (context) {
        return AnimationWidget(
          globalKey: rootGlobalKey,
          piuWidget: piuWidget,
          endOffset: endOffset,
          startOffset: startOffset,
          maxWidth: maxWidth,
          minWidth: minWidth,
          millisecond: millisecond ?? 2000,
          animationFinishCallBack: _finishCallBack,
          doSomethingBeginCallBack: doSomethingBeginCallBack,
          doSomethingFinishCallBack: doSomethingFinishCallBack,
        );
    });

    //主页面插入浮层
    Overlay.of(rootGlobalKey.currentContext!)!.insert(_overlayEntry);

    _finishCallBack = (status) {
      if (status == AnimationStatus.completed) {
        _overlayEntry.remove();
      }
    };
  }

}

class AnimationWidget extends StatefulWidget {
  const AnimationWidget(
      {Key? key,
        required this.globalKey,
        required this.piuWidget,
        required this.endOffset,
        required this.startOffset,
        required this.maxWidth,
        required this.minWidth,
        required this.millisecond,
        required this.animationFinishCallBack,
        this.doSomethingBeginCallBack,
        this.doSomethingFinishCallBack})
      : super(key: key);

  //主页面GlobalKey
  final GlobalKey globalKey;

  //piu动画widget
  final Widget piuWidget;

  //终点位置
  final Offset endOffset;

  //起点位置
  final Offset startOffset;

  //初始最大宽度
  final double maxWidth;

  //悬停最小宽度
  final double minWidth;

  //动画时长
  final int millisecond;

  //动画结束回调
  final Function? animationFinishCallBack;

  //动画开始事件回调
  final Function? doSomethingBeginCallBack;

  //动画结束时间回调
  final Function? doSomethingFinishCallBack;

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _scaleAnimation; //前置缩放动画
  late Animation<double> _scaleMinAnimation; //后置缩放动画
  late Animation<double> _alphaAnimation; //渐变动画
  late Animation<double> _rotationZAngleAnimation; //旋转动画
  Animation<double>? _pathAnimation; //piu移动路径动画（贝塞尔曲线）

  double _left = 0;
  double _top = 0;
  PathMetric? _metric;
  double _pathListLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //曲线动画
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // ignore: unnecessary_null_comparison
      if(widget.startOffset==null){
        Size size = MediaQuery.of(context).size;
        initBezierPathList(Offset((size.width - widget.minWidth) / 2,
            (size.height - widget.minWidth) / 2));
      }else{
        initBezierPathList(Offset((widget.startOffset.dx - widget.minWidth) / 2,
            (widget.startOffset.dy - widget.minWidth) / 2));
      }


      _pathAnimation = Tween<double>(begin: 0.0, end: _pathListLength).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(
            0.4, 1, //间隔，前40%的动画时间
            curve: Curves.easeOutExpo,
          ),
        ),
      );
    });

    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.millisecond),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.animationFinishCallBack != null) {
            widget.animationFinishCallBack!(status);
          }
          if (widget.doSomethingFinishCallBack != null) {
            widget.doSomethingFinishCallBack!(true);
          }
        } else if (status == AnimationStatus.forward) {
          if (widget.doSomethingBeginCallBack != null) {
            widget.doSomethingBeginCallBack!();
          }
        }
      })
      ..addListener(() {
        setState(() {});
      })
      ..forward();

    //前置缩放动画
    _scaleAnimation =
        Tween<double>(begin: widget.maxWidth, end: widget.minWidth).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              0.0, 0.4, //间隔，前40%的动画时间
              curve: Curves.easeOutExpo,
            ),
          ),
        );

    _scaleMinAnimation = Tween<double>(begin: widget.minWidth, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.4, 1, //间隔，后60%的动画时间
          curve: Curves.easeOutExpo,
        ),
      ),
    );

    _alphaAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0, 0.4, //间隔，前40%的动画时间
          curve: Curves.easeOutExpo,
        ),
      ),
    );

    _rotationZAngleAnimation = Tween<double>(begin: 180, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0, 0.4, //间隔，前40%的动画时间
          curve: Curves.linearToEaseOut,
        ),
      ),
    );
  }

  //初始化曲线路径及长度
  initBezierPathList(Offset startOffset) {
    Path path = getPath(startOffset, widget.endOffset);
    PathMetrics pathMetrics = path.computeMetrics();
    _metric = pathMetrics.elementAt(0);
    _pathListLength = _metric!.length;
  }

  //路径
  Path getPath(Offset start, Offset end) {
    // print("start dx = ${start.dx}  end dx = ${end.dx}");
    double centerPointX = start.dx > end.dx ? start.dx : end.dx;
    double centerPointY = start.dy > end.dy ? start.dy : end.dy;
    Path path = Path();
    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(centerPointX / 2, centerPointY / 2, end.dx, end.dy);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.startOffset == null){
      _left = (MediaQuery.of(context).size.width - _scaleAnimation.value) / 2;
      _top = (MediaQuery.of(context).size.height - _scaleAnimation.value) / 2;
    }else{
      _left = (widget.startOffset.dx - _scaleAnimation.value) / 2;
      _top = (widget.startOffset.dy - _scaleAnimation.value) / 2;
    }


    double dx = 0;
    double dy = 0;

    if (_metric != null) {
      Tangent? t = _metric!.getTangentForOffset(_pathAnimation!.value);
      dx = t!.position.dx;
      dy = t.position.dy;
      // print("Tangent dx= ${t.position.dx}  dy = ${t.position.dy}");
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          left: _scaleAnimation.value > widget.minWidth ? _left : dx,
          top: _scaleAnimation.value > widget.minWidth ? _top : dy,
          width: _scaleAnimation.value > widget.minWidth
              ? _scaleAnimation.value
              : _scaleMinAnimation.value,
          height: _scaleAnimation.value > widget.minWidth
              ? _scaleAnimation.value
              : _scaleMinAnimation.value,
          child: Container(
            // transform:
            // Matrix4.rotationY(_rotationZAngleAnimation.value * pi / 180),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) //翻转深度效果
              ..rotateY(_rotationZAngleAnimation.value * pi / 180),
            //翻转弧度
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Colors.red,
              borderRadius:
              BorderRadius.all(Radius.circular(widget.minWidth / 2)),
            ),
            clipBehavior: Clip.hardEdge,
            child: Opacity(
              opacity: _alphaAnimation.value,
              child: widget.piuWidget,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
}