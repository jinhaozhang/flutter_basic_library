import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
// 打印类型
enum ApmLogType {
  V, // verbose
  D, // debug
  I,// info
  W, // warn
  E, // error
}

///  https://github.com/smartbackme/emas_tlog
class EmasTlog {
  static const MethodChannel _channel = MethodChannel('emas_tlog');
  static void updateNickName(String name) {
    _channel.invokeMethod("updateNickName",{"name": name});
  }
  ///主动上报日志
  static void comment(){
    _channel.invokeMethod("comment");
  }
// alicloud 供外部dart调用
/*
* appKey
appSecret
tlogRsaSecret
appVersion // App版本
nick // 用户昵称 都不能为空
* */
  static void init(String appKey,String appSecret,String rsaPublicKey,
      String appKeyIos,String appSecretIos,String rsaPublicKeyIos,
      {String androidChannel = "line",String userNick = "NoLogin",ApmLogType? type,bool debug = true}){
    Map<String, dynamic> params = <String, dynamic>{};
    params['appKey'] = appKey;
    params['appSecret'] = appSecret;
    params['rsaPublicKey'] = rsaPublicKey;
    params['appKeyIos'] = appKeyIos;
    params['appSecretIos'] = appSecretIos;
    params['rsaPublicKeyIos'] = rsaPublicKeyIos;
    if(Platform.isIOS){
      params['channel'] = "App Store";
    }else if(Platform.isAndroid){
      params['channel'] = androidChannel;
    }
    params['userNick'] = userNick;
    params['debug'] = debug;
    String t = "d";
    if(Platform.isIOS){
      t = "d";
    }else if(Platform.isAndroid){
      t = "v";
    }
    switch(type){
      case ApmLogType.V:
        if(Platform.isIOS){
          t = "d";
        }else if(Platform.isAndroid){
          t = "v";
        }
        break;
      case ApmLogType.D:
        t = "d";
        break;
      case ApmLogType.I:
        t = "i";
        break;
      case ApmLogType.W:
        t = "w";
        break;
      case ApmLogType.E:
        t = "e";
        break;
    }
    params['type'] = t;
// 注册方法
    _channel.invokeMethod("init",params);
  }
}