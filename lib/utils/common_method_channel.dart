
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';


/**
 * 通用的桥接方法
 */

/**
 * flutter调用app的吐司方法
 */
showToast(String parmes) =>
    ChannelUtils.instance.flutterCallApp('showToast', parmes: parmes);

///调用原生的复制文本的方法
copyContent(String parmes) =>
    ChannelUtils.instance.flutterCallApp('copyContent', parmes: parmes);

///调用原生的log输出
log(String parmes) {
  if (kDebugMode) {
    print(parmes);
    ChannelUtils.instance.flutterCallApp('log', parmes: parmes);
  }
}

///返回原生app内
goBackApp([dynamic parmes]) {
  ChannelUtils.instance.flutterCallApp('goBackApp');
}

///调用app的登录界面  token失效
loginAgainApp([dynamic parmes]) =>
    ChannelUtils.instance.flutterCallApp('loginAgainApp', parmes: parmes);

///拨打电话
callPhoneNumber(String phone) =>
    ChannelUtils.instance.flutterCallApp('callPhone', parmes: phone);

///调用阿里的emas服务
callAliEmas(ApmLogType type,String? message,{String? module,String? tag}){
  Map<String, String> params = <String, String>{};
  params['module'] = module??"";
  var method;
  if(Platform.isIOS){
    params['message'] = "${tag??""}-${message??""}";
    switch(type){
      case ApmLogType.V:
        method = "debug";
        break;
      case ApmLogType.D:
        method = "debug";
        break;
      case ApmLogType.I:
        method = "info";
        break;
      case ApmLogType.W:
        method = "warn";
        break;
      case ApmLogType.E:
        method = "error";
        break;
    }
    params["method"] = method;
    ChannelUtils.instance.flutterCallApp("callAliEmas",parmes:params);
  }else if(Platform.isAndroid){
    params['tag'] = tag??"";
    params['message'] = message??"";
    switch(type){
      case ApmLogType.V:
        method = "logv";
        break;
      case ApmLogType.D:
        method = "logd";
        break;
      case ApmLogType.I:
        method = "logi";
        break;
      case ApmLogType.W:
        method = "logw";
        break;
      case ApmLogType.E:
        method = "loge";
        break;
    }
    ChannelUtils.instance.flutterCallApp(method,parmes:params);
  }
}
