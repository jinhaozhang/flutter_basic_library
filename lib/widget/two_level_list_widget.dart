import 'package:flutter/material.dart';

abstract class TwoLevelBaseBean{

  bool isOpen = false;
  int index = 0;
  int  getChildSize();

}

typedef ChildViewCreate = Widget Function(int parentIndex,int childIndex);
typedef GroupViewCreate = Widget Function(int parentIndex);

class GroupListView<T extends TwoLevelBaseBean> extends StatefulWidget{

  List<T>? data;
  GroupViewCreate? parentWidget;
  ChildViewCreate? childWidget;

  GroupListView({@required this.data,@required this.parentWidget,@required this.childWidget,Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => GroupListViewState();

}

class GroupListViewState extends State<GroupListView> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (context,index){
      return Column(
        children: [
          widget.parentWidget!(index),
          ChildListView(widget.data![index],widget.childWidget!,index),
        ],
      );
    },
      itemCount: widget.data!.length,);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ChildListView<T extends TwoLevelBaseBean> extends StatefulWidget{

  T _data;
  ChildViewCreate childWidget;
  int parentIndex;

  ChildListView(this._data,this.childWidget,this.parentIndex,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChildListViewState();

}

class ChildListViewState extends State<ChildListView> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (context,index){
        return Offstage(
          offstage:!  widget._data.isOpen,
          child: widget.childWidget(widget.parentIndex,index),
        );
    },
      itemCount: widget._data.getChildSize(),
      shrinkWrap: true,/*内嵌listView 这个值要设置成true*/
      primary: true,
      physics: const NeverScrollableScrollPhysics(), /*嵌套滑动这个也得限制 不然 滑动子列表 外层不滚动*/
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}