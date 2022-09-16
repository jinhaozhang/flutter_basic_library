import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';
import 'package:flutter_basic_library/utils/navigator_util.dart';


abstract class BaseTabState<T extends StatefulWidget> extends State<T>  with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin{

  String get titleName;///标题名称

  TabController? _tabController;

  List<Widget> get contentChildList;///显示的布局内容

  List<String> get tabs;///显示的标题

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    ///此代码单独运行没有问题  关联Android后  android正式打包release的环境下 首次启动flutter页面，且是该页面的情况下 会出现tab标题不展示的问题  延迟重新刷新解决此问题
    Future.delayed(const Duration(milliseconds: 100),()=>setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(title:GestureDetector(child:  Text(titleName,style:const TextStyle(color: Colors.black),),onTap: clickTitle,),backgroundColor:Colors.white,elevation:0,bottom: TabBar(
          // isScrollable:true,///多个标签时滚动加载
          labelColor: ColorUtil(color_376EFF), // 标签的颜色
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 16.sp),
          unselectedLabelColor:Colors.black54,// 未选中标签的颜色
          unselectedLabelStyle:  TextStyle( fontWeight: FontWeight.w400,color: Colors.black54, fontSize: 14.sp),// 未选中标签的字体
          controller: _tabController,
          // indicatorColor: Colors.red,// 标签指示器的颜色
          // indicatorSize: TabBarIndicatorSize.label,// 指示器的大小
          // indicatorWeight: 4.0,// 指示器的权重，即线条高度
          indicator: IndicatorStyle(type:IndicatorType.runderline_fixed,height:3.w,lineWidth:60.w,color:ColorUtil(color_376EFF)),
          tabs: tabs.map((e) {
            return Tab(
              text: e,
            );
          }).toList()),
        leading:IconButton(icon: const Icon(Icons.arrow_back_ios_outlined,color: Colors.black87), onPressed: () {
          clickBackButton();
        }),
        actions:  getTitleRight(),
      ),
      body:TabBarView(
        controller: _tabController,
        children: contentChildList,
      ),
    );
  }

  ///点击标题的按键
  clickTitle(){

  }

  ///点击返回的按键
  clickBackButton(){
    NavigatorUtil.goBack(context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  ///标题右边的组件信息
  List<Widget> getTitleRight()=> [];


}
