import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library_example/bean/user.dart';



/**
  * by zjh
  * 2022/9/16  11:14
  */
class MvvmDemoPage extends StatefulWidget{

  @override
  _MvvmDemoPageState createState()=>_MvvmDemoPageState();

}

class _MvvmDemoPageState extends MvvmBaseState<MvvmDemoPage,LoginViewModel>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = LoginViewModel();
    viewModel.getViewModelData();
  }

  @override
  // TODO: implement contentChild
  get contentChild => Column(
    children: [
      getPubMaterialButton('登录',callback: (){
        viewModel.getViewModelData();
      }),

      Text(viewModel.userData!=null ? viewModel.userData!.appToken! : "123456"),

    ],
  );


  @override
  // TODO: implement titleName
  String get titleName => 'mvvm demo';

}

class LoginData{
  static login(SuccessData successData){
    NetUtils.instance.request((json) => UserData.fromJson(json), '/api/v4/ptyw/login',params:{"loginMobile": '13100000001', "loginPasswd": 'Aa.88888888'},success: successData,error: (e){
      // EasyLoading.showToast('"error code = ${e.code}, massage = ${e.message}"');
    });
  }
}

class LoginViewModel extends BaseViewModel{

  UserData? _userData;

  get userData => _userData;

  set userDataValue(UserData userData){
    _userData=userData;
    notifyListeners();
  }

  @override
  getViewModelData() {
    // TODO: implement getViewModelData
    LoginData.login((data){
      setStatus=1;
      userDataValue = data;
    });
  }
}

