

import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/**
 * 统一的设置下拉 上拉的样式
 *
 *  @override
    Widget build(BuildContext context) {
    return RefreshConfigAll(
    child: MyMaterialApp(
    widget: DemoListPage(),
    navigatorObservers:[RouteUtils.instance],
    generator: router.generator,
    color:  ColorUtil(color_F3F5FC),
    ).getMaterIalApp(context)
    ).getConfig();

    }
 */
class RefreshConfigAll{


  Widget child;

  RefreshConfigAll({required this.child});

  getConfig(){
    return RefreshConfiguration(
        maxOverScrollExtent: 100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
        footerTriggerDistance: -60, // 底部触发刷新的越界距离
        maxUnderScrollExtent: 100, // 底部最大可以拖动的范围
        enableScrollWhenRefreshCompleted:
        true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
        enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
        hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
        enableBallisticLoad: true,
        //
        headerBuilder: () => const WaterDropHeader(), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
        footerBuilder:  () => const ClassicFooter(),
        child: child
    );
  }

}