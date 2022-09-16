// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/services.dart';

typedef CallBackApp = Function(bool isScuess,dynamic argument);

const _platformMethod = MethodChannel("app/methodChannel");
const _eventChannel = EventChannel('app/eventChannel');
const _basicMessageChannel = BasicMessageChannel('app/basicMessageChannel', StringCodec());

class ChannelUtils{
  static final ChannelUtils instance = ChannelUtils._internal();
  factory ChannelUtils() => instance;
  final List<FlutterCallClickItem> _chickEvents = [];

  bool isStartPage=false;///标记与原生的方法是否可以交互

  ChannelUtils._internal(){
    _platformMethod.setMethodCallHandler((call) async{
      return appCallFlutter(call);
    });
  }

  ///flutter调用app中的方法
  flutterCallApp(String methodName,{dynamic parmes,CallBackApp? callBack}) async{
    if(isStartPage){
      try {
        var argument;
        if(parmes==null){
          argument = await _platformMethod.invokeMethod(methodName);
        }else{
          argument = await _platformMethod.invokeMethod(methodName,parmes);
        }
        if(callBack!=null){
          if(argument == null){
            callBack(true,"无返参");
          }else{
            callBack(true,argument);
          }
        }
      } on PlatformException catch (e) {
        if(callBack!=null){
          callBack(false,'调用$methodName失败');
        }
      }
    }
  }

  ///app调用flutter中的方法
  appCallFlutter(MethodCall call) {
      if(_chickEvents.any((element) => element.isSameMethodName(call.method))){
        _chickEvents.where((element) => element.isSameMethodName(call.method)).forEach((element2) {
          element2.handler(call.arguments);
        });
      }
  }

  ///添加flutter的监听事件
  addClickEvent(String methodName,dynamic subject,Function(dynamic arguments) handle){
    if(_chickEvents.isNotEmpty){
      if(!_chickEvents.any((element) =>element.isSameMethodName(methodName) && element.isSameSubject(subject))){
        _chickEvents.add(FlutterCallClickItem(methodName,subject,handle));
      }
    }else{
      _chickEvents.add(FlutterCallClickItem(methodName,subject,handle));
    }
  }


  ///根据方法名称清空监听事件
  clearEventByMethod(String methodName){
    _chickEvents.removeWhere((element) => element.isSameMethodName(methodName));
  }

  ///根据主体对象清空监听事件
  clearEventBySubject(dynamic subject){
    _chickEvents.removeWhere((element) => element.isSameSubject(subject));
  }

  ///清空所有的监听事件
  clearAllClickEvent(){
    _chickEvents.clear();
  }

  /*
 * BasicMessageChannel
 * 实现Flutter 调用Android iOS原生方法并回调
 * arguments 发送给原生的参数
 * return数据 原生发给Flutter的参数
 */
  Future<Map> toolsBasicChannelMethodWithParams(dynamic arguments) async {
    var result;
    try {
      result = await _basicMessageChannel.send(arguments!);
    } catch (e) {
      result = {'Failed:'};
    }
    return result;
  }


/*
 * EventChannel
 * return数据 原生发给Flutter的参数
 * result listen监听结果
 */
  toolsEventChannelMethod(Function result) {
    //不指定返回值类型，函数返回值默认为Object
    _eventChannel.receiveBroadcastStream().listen((event){
      result(event);
    });
  }
}

class FlutterCallClickItem{
  final String _clickName;

  final dynamic _widgetTarget;

  Function(dynamic arguments) handler;

  FlutterCallClickItem(this._clickName,this._widgetTarget,this.handler);

  bool isSameSubject(dynamic subject){
    return _widgetTarget == subject;
  }

  bool isSameMethodName(String mehtodName){
    return _clickName == mehtodName;
  }

}