import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter/material.dart';


abstract class BaseState<T extends StatefulWidget> extends State<T>{

  int showStatus=0;///0为初始显示布局 1为数据正常的显示布局 2为空数据的页面展示 3为网络错误展示的布局内容

  String get titleName;///标题名称

  get contentChild;///显示的布局内容

  void resetData();

    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: getTitleWidget() ,
      body: getContentWidget(),
    );
  }

  Widget getContentWidget(){
    if(showStatus ==3 ){
      return errorWidget((){
        resetData();
      },);
    }else if(showStatus ==1){
      return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: ColorUtil(color_F3F5FC)),
        child: contentChild,
      );
    }else if(showStatus ==2){
      return emptyWidget();
    }else{
      return Container(
        decoration:const BoxDecoration(color: Colors.white),
      );
    }
  }

  ///顶部的标题占位  重写可以自定义
  PreferredSizeWidget getTitleWidget(){
    return getPublicAppBar(context, titleName);
  }

  @override
  void dispose() {
    ChannelUtils.instance.clearEventBySubject(this);
    // TODO: implement dispose
    super.dispose();
  }

  ///数据为空时 ui展示
  Widget emptyWidget();

  ///网络失败的 ui展示
  Widget errorWidget(VoidCallback callback);
}
