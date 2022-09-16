
import 'package:dio/dio.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';

class NetLogInterceptorsWrapper extends InterceptorsWrapper{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super. onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    log('path ==${response.requestOptions.baseUrl}${response.requestOptions.path} '
        '\n method ==${ response.requestOptions.method} connectTimeout ==${ response.requestOptions.connectTimeout} receiveTimeout ==${ response.requestOptions.receiveTimeout} '
        '\n queryParameters ==${ response.requestOptions.queryParameters.toString()} '
        '\n header ==${ response.requestOptions.headers.toString()} '
        '\n 入参数据 ==${ response.requestOptions.data} '
        '\n 出参数据==${response.toString()}'
      );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    log('网络报错==${err.message}');
    super.onError(err, handler);
  }

}