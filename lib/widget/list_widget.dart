// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/widget/empty_widget.dart';
import 'package:flutter_basic_library/widget/error_widget.dart';


typedef ListItemCreate<T> = Widget Function(int index,T t);
typedef ListTopCreate = Widget Function();
typedef LoadDate = Function(int index, SuccessListData successData, ErrorCallBack errorDate, LoginCallBack loginAgain);

GlobalKey<ListViewWidgetState> listViewWidgetKey = GlobalKey();

GlobalKey<ListViewWidgetState> listViewWidgetSearchKey = GlobalKey();

class ListViewWidget<T> extends StatefulWidget{

  ListItemCreate? itemCreate;///条目的UI
  ListTopCreate? topCreate;///顶部的UI
  LoadDate? loadDate;///加载数据的方法
  ListViewWidget({this.itemCreate,this.loadDate,this.topCreate,Key? key}):super(key: key);

  @override
  ListViewWidgetState createState() => ListViewWidgetState();

}

class ListViewWidgetState<T> extends BaseListReFreshState<T,ListViewWidget>{

  ListViewWidgetState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFirst=true;
  }


  @override
  // TODO: implement contentChild
  get contentChild => ListView.builder(itemBuilder: (context,index){
    return widget.itemCreate!(index,dataList[index]);
  },
  itemCount: dataList.length,);

  @override
  // TODO: implement isShowScaffold
  bool get isShowScaffold => false;

  @override
  Widget getTopWidget() {
    // TODO: implement getTopWidget
    // widget.topCreate!() ?? super.getTopWidget()
    if(widget.topCreate==null){
      return super.getTopWidget();
    }else{
      return widget.topCreate!();
    }
  }

  @override
  void getData(int pageIndex, successData, errorDate, loginAgain) {
    // TODO: implement getData
    widget.loadDate!(pageIndex,successData,errorDate,loginAgain);
  }

  @override
  Widget emptyWidget() {
    // TODO: implement emptyWidget
    return EmptyPager();
  }

  @override
  Widget errorWidget(VoidCallback callback) {
    // TODO: implement errorWidget
    return NetErrorPager(callBack: callback,);
  }

}