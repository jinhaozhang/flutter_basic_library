import 'package:flutter/material.dart' ;
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/widget/empty_widget.dart';
import 'package:flutter_basic_library/widget/error_widget.dart';
import 'package:provider/provider.dart';

abstract class MvvmBaseState<T extends StatefulWidget, M extends BaseViewModel>
    extends State<T> {
  late M viewModel;

  String get titleName;///标题名称

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<M>(builder: (BuildContext, provie, _) {
        return Scaffold(
          appBar: getTitleWidget(),
          body: getContentWidget(),
        );
      }
    ),);
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
    if(viewModel.showStatus ==3 ){
      return errorWidget((){
        viewModel.getViewModelData();
      });
    }else if(viewModel.showStatus ==1){
      return  Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: ColorUtil(color_F3F5FC)),
        child: contentChild,
      );
    }else if(viewModel.showStatus ==2){
      return emptyWidget();
    }else{
      return Container(
        decoration:const BoxDecoration(color: Colors.white),
      );
    }
  }

  ///显示的布局内容
  get contentChild;

  ///数据为空时 ui展示
  Widget emptyWidget()=>EmptyPager();

  ///网络失败的 ui展示
  Widget errorWidget(VoidCallback callback)=>NetErrorPager(callBack: callback,);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


abstract class BaseViewModel with ChangeNotifier {

  int _showStatus=0;///0为初始显示布局 1为数据正常的显示布局 2为空数据的页面展示 3为网络错误展示的布局内容

  int get showStatus => _showStatus;

  set setStatus(int status) {
    _showStatus=status;
    notifyListeners();
  }

  ///获取数据来源
  getViewModelData();

}