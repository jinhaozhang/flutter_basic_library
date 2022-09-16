import 'package:flutter/material.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/widget_utils.dart';
import 'package:flutter_basic_library/utils/widget_padding.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';
import 'package:flutter_basic_library/net/NetUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///L为列表数据模型，T为具体widget
abstract class BaseListReFreshState<L, T extends StatefulWidget>
    extends State<T> {
  List<L> dataList = [];
  int pageIndex = 1;
  String? _titleName;
  late RefreshController refreshController;
  get contentChild;
  bool isNetError=false;///是否网络错误
  bool isFirst=true;///是否首次加载
  String get titleName => _titleName ?? '';///标题名称
  VoidCallback? backCall;///返回的按钮

  set titleName(String titleNameChild) => _titleName = titleNameChild;

  void _onRefresh() async {
    loadData(loadMore: false);
  }

  void _onLoading() async {
    loadData(loadMore: true);
  }

  void getListData(){
    loadData(loadMore: false);
  }

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: false);
    loadData(loadMore: false);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getContentTypeWidget();
  }

  Widget getContentTypeWidget(){
    if(isShowScaffold){
      return Scaffold(
        appBar: getPublicAppBar(context, titleName,goBack: backCall),
        body: Column(
          children: [
            getTopWidget(),
            getContentWidget(),
          ],
        ).bgStyle(margin:const EdgeInsets.all(0),padding:const EdgeInsets.all(0),bgColor: ColorUtil(color_F3F5FC),radius:const Radius.circular(0)),
      );
    }else{
      return Column(
        children: [
          getTopWidget(),
          getContentWidget(),
        ],
      ).bgStyle(margin:const EdgeInsets.all(0),padding:const EdgeInsets.all(0),bgColor: ColorUtil(color_F3F5FC),radius:const Radius.circular(0));
    }
  }

  ///是否需要Scaffold的脚手架显示  默认是需要  重写后可以不显示Scaffold
  bool get isShowScaffold => true;


  ///获取显示的内容
  Widget getContentWidget(){
    if(isFirst){
      return Container(
          decoration:const BoxDecoration(color: Colors.white),
      );
    }else{
      if(dataList.isNotEmpty){
        return getListWidet();
      }else if(dataList.isEmpty && !isNetError){
        return emptyWidget();
      }else{
        return errorWidget(() {
          loadData(loadMore: false);
        });
      }
    }
  }

  ///数据为空时 ui展示
  Widget emptyWidget();

  ///网络失败的 ui展示
  Widget errorWidget(VoidCallback callback);

  Widget getListWidet(){
    return Expanded(child: SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      // WaterDropHeader、ClassicHeader、CustomHeader、LinkHeader、MaterialClassicHeader、WaterDropMaterialHeader
      header: CustomHeader(
        builder: (BuildContext context, RefreshStatus? mode) {
          Widget body;
          if (mode == RefreshStatus.idle) {
            body =const Text("下拉刷新数据");
          } else if (mode == RefreshStatus.refreshing) {
            body = Container(
              height: 60.0.w,
              child:const Text("正在刷新"),
              // child: Lottie.asset('assets/79609-loading-button.json',
              //     height: 60),
            );
          } else if (mode == RefreshStatus.failed) {
            body = InkWell(
              onTap: () {
                _onLoading();
              },
              child:const Text("下拉刷新失败"),
            );
          }  else {
            body =const Text("下拉刷新结束");
          }
          return Center(
            child:Container(
              height: 40.0.w,
              child: body,
            ),
          );
        },
      ),
      // ClassicFooter、CustomFooter、LinkFooter、LoadIndicator
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body =const Text("上拉加载更多");
          } else if (mode == LoadStatus.loading) {
            body = Container(
              height: 60.0.w,
              child:const Text("正在加载"),
              // child: Lottie.asset('assets/79609-loading-button.json',
              //     height: 60),
            );
          } else if (mode == LoadStatus.failed) {
            body = InkWell(
              onTap: () {
                _onLoading();
              },
              child:const Text("加载失败，点击重新加载"),
            );
          } else if (mode == LoadStatus.noMore) {
            body = InkWell(
              onTap: () {
                _onLoading();
              },
              child:const Text("暂无更多数据"),
            );
          } else {
            body =const Text("暂无更多数据");
          }
          return Container(
            height: 55.0.w,
            child: Center(child: body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: contentChild,
    ),);
  }

  ///顶部的组件占位
  Widget getTopWidget(){
    return  SizedBox(height: 1.w,);
  }

  //获取对应页吗的数据
  void getData(int pageIndex,SuccessListData successData,ErrorCallBack errorDate,LoginCallBack loginAgain);

  ///从Mo中解析出list数据
  // List<L> parseList(M result);

  Future<void> loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
     getData(currentIndex,
        (list){
          isNetError=false;
          isFirst=false;
          if (mounted) {
            setState(() {
              if (loadMore) {
                if (list.isEmpty) {
                  refreshController.loadNoData();
                } else {
                  refreshController.loadComplete();
                }
                //合成新数组
                dataList = [...dataList, ...list];
                if (list.isNotEmpty) {
                  pageIndex++;
                }
              } else {
                dataList.clear();
                dataList = list  as  List<L>;
                refreshController.refreshCompleted(resetFooterState: true);
              }
            });
          }
        },
        (error){
            setState(() {
              isNetError=true;
              isFirst=false;
              if (loadMore) {
                refreshController.loadFailed();
              } else {
                refreshController.refreshFailed();
              }
            });
        },
        (){

        });
  }
}
