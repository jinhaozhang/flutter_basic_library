
import 'package:dio/dio.dart';
import 'package:flutter_basic_library/net/NetUtils.dart';

/**
 * 上传下载的实体
 */
class DownUpLoadBean{

  String? key;

  CancelToken? cancelToken;

  int? total;

  int? current;

  ProgressCallback? progressCallback;///过程监听

  ///成功监听
  Function? success;

  ///失败监听
  ErrorCallBack? error;

  DownUpLoadBean({required this.key,required this.cancelToken, this.total, this.current});

  setDownAndUpListener({ProgressCallback? progressCallback,Function? success,ErrorCallBack? error}){
    this.progressCallback = progressCallback;
    this.success=success;
    this.error=error;
  }

}