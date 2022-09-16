
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_basic_library_example/net/more_domain_name.dart';

class MyInterceptorsWrapper extends InterceptorsWrapper{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    setRequestBeforeParameters(options);
    super. onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    // print('path ==${response.requestOptions.baseUrl}${response.requestOptions.path} '
    //     '\n method ==${ response.requestOptions.method} connectTimeout ==${ response.requestOptions.connectTimeout} receiveTimeout ==${ response.requestOptions.receiveTimeout} '
    //     '\n queryParameters ==${ response.requestOptions.queryParameters.toString()} '
    //     '\n header ==${ response.requestOptions.headers.toString()} '
    //     '\n 入参数据 ==${ response.requestOptions.data} '
    //     '\n 出参数据==${response.toString()}'
    //   );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    // log('网络报错==${err.message}');
    super.onError(err, handler);
  }

  ///请求前添加参数
  setRequestBeforeParameters( RequestOptions options){
    Map<String,String> map = {
      "deviceModel":PublicParameter.deviceModel,
      "deviceId":PublicParameter.deviceId,
      "osVersion":PublicParameter.osVersion,
      "appVersion":PublicParameter.app_version,
      "networkType":PublicParameter.net_type,
      "os":Platform.isIOS ? "IOS" : "ANDROID"
    };
    options.queryParameters.addAll(map);
    if(DomainOne.urlMap.containsValue(options.path)){
      options.baseUrl=DomainOne.baseApi!;
      if(DomainOne.api_token!=null && DomainOne.api_token!.isNotEmpty){
        options.headers.addAll({
          "api-token":(DomainOne.api_token!=null && DomainOne.api_token!.isNotEmpty) ? DomainOne.api_token : ""
        });
      }
    }else{
      options.baseUrl=PrimaryDomainName.base_url!;
      if(PrimaryDomainName.app_token!=null && PrimaryDomainName.app_token!.isNotEmpty){
        options.headers.addAll({
          "jxs-app-token":(PrimaryDomainName.app_token!=null && PrimaryDomainName.app_token!.isNotEmpty) ? PrimaryDomainName.app_token : ""
        });
      }
    }

    ///删除没有值的参数
    if(options.data!=null){
      options.data!.removeWhere((key, value) => value==null || value.toString().isEmpty);
    }
  }
}