import 'package:flutter/material.dart';
import 'package:flutter_basic_library/net/BaseEntity.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';
import 'package:flutter_basic_library/utils/navigator_util.dart';


abstract class MvpBaseView {

  BuildContext getContext();

  ///展示空页面
  showEmptyPage();

  ///展示网络失败的页面
  showErrorPage();

  ///修改页面的状态
  chanceStatus(int status);

}


abstract class MvpBasePresenter<T extends MvpBaseView>{

  T view;
  CancelToken? cancelToken;

  MvpBasePresenter(this.view){
    cancelToken = CancelToken();
  }

  void deactivatePresenter() {}

  void disposePresenter() {
    //请求取消
    if(cancelToken!=null){
      if(cancelToken!.isCancelled){
        cancelToken!.cancel();
      }
    }
  }

  void initPresenter();

  ///返回的数据为对象专用
  void requestData<V>(JsonToBean<V> jsonToBean,String url, {NetMethod method = NetMethod.POST,CancelToken? cancelToken,Map? params,Map<String,dynamic>? queryParameters,
    SuccessListData? success, ErrorCallBack? error,Function? loginAgain,bool isShowLoading=true,bool isShowErrorPage=true}){
    NetUtils.instance.request(jsonToBean,url,cancelToken: cancelToken,isShowLoading: isShowLoading,
        params: params,method: method,queryParameters:queryParameters,
        success: (list){
          success!(list);
        },
        error: (e){
          error!(e);
          if(isShowErrorPage){
            view.showErrorPage();
          }
        },
        loginAgain: (){

        }
    );
  }


  ///返回的数据为列表专用
  void requestList<V>(JsonToBean<V> jsonToBean,String url, {NetMethod method = NetMethod.POST,CancelToken? cancelToken,Map? params,Map<String,dynamic>? queryParameters,
    SuccessListData? success, ErrorCallBack? error,Function? loginAgain,bool isShowLoading=true,bool isShowErrorPage=true}){
    NetUtils.instance.requestList(jsonToBean,url,cancelToken: cancelToken,isShowLoading: isShowLoading,
        params: params,method: method,queryParameters:queryParameters,
        success: (list){
          success!(list);
          view.chanceStatus(1);
        },
        error: (e){
          error!(e);
          if(isShowErrorPage){
            view.showErrorPage();
          }
        },
        loginAgain: (){

        }
    );
  }
}


abstract class MvpBaseState<T extends StatefulWidget,V extends MvpBasePresenter> extends State<T> implements MvpBaseView{

  V? presenter;

  bool _isShowDialog = false;

  bool isScaffold=true;///是否有Scaffold

  int showStatus=0;///0为初始显示布局 1为数据正常的显示布局 2为空数据的页面展示 3为网络错误展示的布局内容

  MvpBaseState() {
    presenter = createPresenter();
  }

  void hideLoading() {
    if (mounted && _isShowDialog){
      _isShowDialog = false;
      EasyLoading.dismiss();
    }
  }

  void showLoading() {
    /// 避免重复弹出
    if (mounted && !_isShowDialog){
      _isShowDialog = true;
      EasyLoading.show(status: '加载中...',dismissOnTap: false);
    }
  }

  @override
  showEmptyPage() {
    chanceStatus(2);
  }

  @override
  showErrorPage() {
    chanceStatus(3);
  }

  @override
  chanceStatus(int status) {
    if(mounted){
      setState(() {
        showStatus=status;
      });
    }
  }

  @override
  BuildContext getContext() {
    // TODO: implement getContext
    return context;
  }

  showToast(String msg,{Duration? duration}){
    EasyLoading.showToast(msg,duration: duration ?? const Duration(seconds: 2));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    presenter = createPresenter();
    presenter!.initPresenter();
    getData();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    presenter!.deactivatePresenter();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    presenter!.disposePresenter();
    ChannelUtils.instance.clearEventBySubject(this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isScaffold
        ?
        Scaffold(
          appBar: getTitleWidget() ,
          body: getContentWidget(),
          )
        :
        getContentWidget();
  }

  ///顶部的标题占位  重写可以自定义
  PreferredSizeWidget getTitleWidget(){
    return AppBar(
      elevation:  1,
      backgroundColor: Colors.white,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_outlined,color: Colors.black87), onPressed: ()=>clickBack()),
      centerTitle: true,
      actions: actions(),
      title: Text(titleName,style: TextStyle(color: Colors.black87,fontSize: 18.sp),).click(() =>clickTitle()),
    );
  }

  ///默认的返回
  clickBack(){
    NavigatorUtil.goBack(context);
  }

  ///点击标题的事件
  clickTitle(){

  }

  List<Widget> actions(){
    return [];
  }

  Widget getContentWidget(){
    if(showStatus ==3 ){
      return errorWidget((){
        getData();
      });
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

  ///实例话数据解析类
  V createPresenter();

  String get titleName;///标题名称

  ///显示的布局内容
  get contentChild;

  ///数据为空时 ui展示
  Widget emptyWidget();

  ///网络失败的 ui展示
  Widget errorWidget(VoidCallback callback);

  ///获取数据
  void getData();

}



/**
 * 标题是搜索框的样式
 */
abstract class MvpBaseSearchState<T extends StatefulWidget,V extends MvpBasePresenter> extends MvpBaseState<T,V> {

 @override
  PreferredSizeWidget getTitleWidget() {
    // TODO: implement getTitleWidget
    return AppBarSearch(height:50.w,backgroundColor:Colors.white,borderRadius: 20.r,autoFocus: true,hintText: '请输入商品的名称',onRightTap:()=>onRightTap(),onSearch:searchKey);
  }

 onRightTap(){
   NavigatorUtil.goBack(context);
 }

 searchKey(String key);

}



/**
 * 标题是tab的切换样式
 */
abstract class MvpBaseTabState<T extends StatefulWidget,V extends MvpBasePresenter> extends MvpBaseState<T,V> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin{

  TabController? _tabController;

  List<Widget> get contentChildList;///显示的布局内容

  List<String> get tabs;///显示的标题

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    ///此代码单独运行没有问题  关联Android后  android正式打包release的环境下 首次启动flutter页面，且是该页面的情况下 会出现tab标题不展示的问题  延迟重新刷新解决此问题
    Future.delayed(const Duration(milliseconds: 100),()=>setState(() {}));
  }

  @override
  PreferredSizeWidget getTitleWidget() {
    // TODO: implement getTitleWidget
    return AppBar(title:GestureDetector(child:  Text(titleName,style:const TextStyle(color: Colors.black),),onTap: clickTitle,),backgroundColor:Colors.white,elevation:0,bottom: TabBar(
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
        clickBack();
      }),
      actions:  actions(),
    );
  }

  @override
  // TODO: implement contentChild
  get contentChild => TabBarView(
    controller: _tabController,
    children: contentChildList,
  );

}