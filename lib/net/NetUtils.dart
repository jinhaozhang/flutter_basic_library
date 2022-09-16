
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/net/BaseEntity.dart';
import 'package:flutter_basic_library/net/ErrorEntity.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'BaseListEntity.dart';
import 'down_up_load_bean.dart';


class NetUtils{
  static final NetUtils instance = NetUtils._internal();
  factory NetUtils() => instance;
  Dio? dio;

  NetUtils._internal();

  /**
   * headers 统一的header信息添加
   * interceptors 过滤器的信息
   * isProxy 是否开启代理  默认不开启
   * PROXY_IP 代理的IP信息
   * baseApi 域名信息
   *
   *   NetUtils.instance.init(headers: {'jxs-login-terminal':'ANDROID'});
   */
  init({ Map<String,dynamic>? headers,InterceptorsWrapper? interceptor,bool isProxy=false,String? PROXY_IP,String? baseApi}){
      BaseOptions options = BaseOptions(
        // baseUrl: baseApi,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        headers: headers!,
        connectTimeout: 30000,
        receiveTimeout: 30000,
      );

      /// 请求拦截器 and 响应拦截机 and 错误处理
      dio = Dio(options);
      dio!.interceptors.add(NetLogInterceptorsWrapper());
      dio!.interceptors.add(interceptor!);
      if(kDebugMode && isProxy){
        (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            // return isProxyCheck && Platform.isAndroid;
            return  true;
          };
          client.findProxy = (url) {
            return 'PROXY $PROXY_IP';
          };
        };
      }
      /// 正式环境拦截日志打印
      // if (!const bool.fromEnvironment("dart.vm.product")) {
      //   dio?.interceptors.add(LogInterceptor(requestBody: false, responseBody: false,error: false));
      // }
      //Cookie管理
      // dio.interceptors.add(CookieManager(CookieJar()));
  }

  // 请求，返回参数为 T
  // method：请求方法，默认请求为NWMethod.POST
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  //queryParameters:url上的参数添加
  Future  request<T>(JsonToBean<T> jsonToBean,String path, {NetMethod method = NetMethod.POST,CancelToken? cancelToken,Map? params,Map<String,dynamic>? queryParameters, SuccessData? success, ErrorCallBack? error,Function? loginAgain,bool isShowLoading=true}) async {
    try {
      if(isShowLoading){
        EasyLoading.show(status: '加载中...',dismissOnTap: false);
      }
      Response? response = await dio?.request(path,
          data: params,
          cancelToken: cancelToken,
          queryParameters:queryParameters,
          onSendProgress:(int a,int b){},
          onReceiveProgress: (int a,int b){},
          options: Options(method: NetMethodValues[method],)
          // options: requestOptions,
      );
      if (response != null) {
        if(response.data["code"]==200){
          if(response.data["data"] !=null){
            BaseEntity entity = BaseEntity<T>.fromJson(json:response.data,dataBean: jsonToBean);
            if(entity.data == null){
              EasyLoading.showToast('实体转换失败！',duration:const Duration(seconds: 2));
            }else{
              success?.call(entity.data);
            }
          }else{
            success?.call(null);
          }
        }else{
          if(response.data["code"]==401){
            // if(loginAgain!=null)loginAgain();
            print('token失效');
          }else{
            EasyLoading.showToast(response.data["msg"],duration:const Duration(seconds: 2));
            error?.call(ErrorEntity(response.data["code"], response.data["msg"]));
          }
        }
      } else {
        error?.call(ErrorEntity(-1, "未知错误"));
      }
      if(isShowLoading){
        EasyLoading.dismiss();
      }
    } on DioError catch(e) {
      EasyLoading.showToast(e.message,duration:const Duration(seconds: 2));
      error?.call(createErrorEntity(e));
    }
  }

  // 请求，返回参数为 List
  // method：请求方法，默认请求为NWMethod.POST
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  // queryParameters:url上的参数添加
  Future requestList<T>(JsonToBean<T> jsonToBean,String path, {NetMethod method = NetMethod.POST,CancelToken? cancelToken,Map? params,Map<String,dynamic>? queryParameters,  SuccessListData? success, ErrorCallBack? error,Function? loginAgain,bool isShowLoading=true}) async {
    try {
      if(isShowLoading){
        EasyLoading.show(status: '加载中...',dismissOnTap: false);
      }
      Response? response = await dio?.request(path,
          data: params,
          cancelToken: cancelToken,
          queryParameters:queryParameters,
          options: Options(method: NetMethodValues[method]));
      if (response != null) {
        if(response.data["code"]==200){
          if(response.data["data"] !=null){
            BaseListEntity entity = BaseListEntity<T>.fromJson(response.data,dataBean: jsonToBean);
            if(entity.data == null){
              EasyLoading.showToast('实体转换失败！',duration:const Duration(seconds: 2));
            }else{
              success?.call(entity.data as List<T>);
            }
          }else{
            success?.call(<T>[]);
          }
        }else{
          if(response.data["code"]==401){
            // if(loginAgain!=null)loginAgain();
            print('token失效');
          }else{
            EasyLoading.showToast(response.data["msg"],duration:const Duration(seconds: 2));
            error?.call(ErrorEntity(response.data["code"], response.data["msg"]));
          }
        }
      } else {
        error?.call(ErrorEntity( -1, "未知错误"));
      }
      if(isShowLoading){
        EasyLoading.dismiss();
      }
    } on DioError catch(e) {
      EasyLoading.showToast(e.message,duration:const Duration(seconds: 2));
      error?.call(createErrorEntity(e));
    }
  }

  /**
   * 记录多个下载的信息
   */
 List<DownUpLoadBean> downUpLoadBeans = [];
  /**
   * 下载文件  支持文件的单点续传功能 前提是该文件在服务器是否支持Range的请求
   * https://yiqing-download.oss-cn-beijing.aliyuncs.com/apk/jxs/prod/android_jxs.3.51.1.apk
   */
  downLoadBreakPointFiles(String urlPath,String savePath) async{
    if(isLoading(urlPath)){
      EasyLoading.showToast('正在下载，请稍后！');
      return;
    }
    int downloadStart = 0;
    File f = File(savePath);
    if (await f.exists()) {
      // 文件存在时拿到已下载的字节数
      downloadStart = f.lengthSync();
    }
    int total = await _getContentLength(dio!, urlPath);
    if(downloadStart == total){
      EasyLoading.showToast('该文件已经下载完成！');
      stop(urlPath);
      return;
    }
    CancelToken cancelToken = CancelToken();
    DownUpLoadBean downUpLoadBean = DownUpLoadBean(key:urlPath,cancelToken: cancelToken);
    downUpLoadBeans.add(downUpLoadBean);
    try {
      var response = await dio!.get<ResponseBody>(
        urlPath,
        options: Options(
          /// Receive response data as a stream
          responseType: ResponseType.stream,
          followRedirects: false,
          headers: {
            /// 加入range请求头，实现断点续传
            "range": "bytes=$downloadStart-",
          },
        ),
      );
      File file = File(savePath);
      RandomAccessFile raf = file.openSync(mode: FileMode.append);
      int received = downloadStart;
      Stream<Uint8List> stream = response.data!.stream;
      StreamSubscription<Uint8List>? subscription;
      subscription = stream.listen(
            (data) {
          /// Write files must be synchronized
          raf.writeFromSync(data);
          received += data.length;
          downUpLoadBean.current = received;
          downUpLoadBean.total = total;
          downUpLoadBean.progressCallback?.call(received, total);
        },
        onDone: () async {
          file.rename(savePath.replaceAll('.temp', ''));
          await raf.close();
          downUpLoadBean.current = downUpLoadBean.total;
          downUpLoadBean.success?.call();
          stop(urlPath);
        },
        onError: (e) async {
          await raf.close();
          downUpLoadBean.error?.call(e);
        },
        cancelOnError: true,
      );
      cancelToken.whenCancel.then((_) async {
        await subscription?.cancel();
        await raf.close();
      });
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print("Download cancelled");
      } else {

      }
      downUpLoadBean.error?.call(createErrorEntity(e));
      stop(urlPath);
    }
    // return response.data;
  }

  /**
   * 下载文件 不支持断点续传功能 每次开始下载都是重新下载
   */
  downLoadFiles(String urlPath,String savePath) async{
    if(isLoading(urlPath)){
      EasyLoading.showToast('正在下载，请稍后！');
      return;
    }
    CancelToken cancelToken = CancelToken();
    DownUpLoadBean downUpLoadBean = DownUpLoadBean(key:urlPath,cancelToken: cancelToken);
    downUpLoadBeans.add(downUpLoadBean);
    Response? response;
    try{
      response  = await dio?.download(urlPath, savePath,cancelToken: cancelToken,
          onReceiveProgress: (int count,int total){
            downUpLoadBean.current =count;
            downUpLoadBean.total =total;
            downUpLoadBean.progressCallback?.call(count, total);
            if( count==total){
              downUpLoadBean.current = downUpLoadBean.total;
              downUpLoadBean.success?.call();
              stop(urlPath);
            }
          });
    }on DioError catch(e){
      downUpLoadBean.error?.call(createErrorEntity(e));
      stop(urlPath);
    }
  }

  /**
   * 上传文件的请求
   */
  fileUplod(String url,String filePath,String loadName) async {
    if(isLoading(url)){
      EasyLoading.showToast('正在上传，请稍后！');
      return;
    }
    Map<String ,dynamic> map = Map();
    // map["auth"]="12345";
    map["file"] = await MultipartFile.fromFile(filePath,filename: loadName);
    ///通过FormData
    FormData formData = FormData.fromMap(map);
    CancelToken cancelToken = CancelToken();
    DownUpLoadBean downUpLoadBean = DownUpLoadBean(key:url,cancelToken: cancelToken);
    downUpLoadBeans.add(downUpLoadBean);
    try{
      Response response = await dio!.post(url, data: formData,
        ///这里是发送请求回调函数
        ///[progress] 当前的进度
        ///[total] 总进度
        onSendProgress: (int progress, int total) {
          print("当前进度是 $progress 总进度是 $total");
          downUpLoadBean.current = progress;
          downUpLoadBean.total = total;
          downUpLoadBean.progressCallback?.call(progress, total);
          if(progress==total){
            downUpLoadBean.current = downUpLoadBean.total;
            downUpLoadBean.success?.call();
            stop(url);
          }
        },);
      ///服务器响应结果
      var data = response.data;

    }on DioError catch (e) {
      downUpLoadBean.error?.call(createErrorEntity(e));
      stop(url);
    }
  }

  /*
   * 获取下载的文件大小
   */
  Future _getContentLength(Dio dio, url) async {
    try {
      Response response = await dio.head(url);
      return int.parse(response.headers.value('content-length')!);
    } catch (e) {
      print("_getContentLength Failed:" + e.toString());
      return 0;
    }
  }

  ///取消下载
  void stop(String url) {
    if(downUpLoadBeans.isNotEmpty){
      downUpLoadBeans.removeWhere((element){
        if(element.key!.compareTo(url) == 0){
          if(!element.cancelToken!.isCancelled) element.cancelToken!.cancel();
        }
        return element.key!.compareTo(url) == 0;
      });
    }
  }

  /**
   * 是否正在下载或上传
   */
  bool isLoading(String url){
    return downUpLoadBeans.any((element) => element.key!.compareTo(url) == 0);
  }

  /**
   * 获取正在下载或上传的实体信息
   */
  DownUpLoadBean? getLoadBean(String url){
    DownUpLoadBean? downUpLoadBean;
    for(int i=0;i<downUpLoadBeans.length;i++){
      if(downUpLoadBeans[i].key?.compareTo(url)==0){
        downUpLoadBean = downUpLoadBeans[i];
        break;
      }
    }
    return downUpLoadBean;
  }


  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:{
        return ErrorEntity(-1, "请求取消");
      }
      break;
      case DioErrorType.connectTimeout:{
        return ErrorEntity(-1, "连接超时");
      }
      break;
      case DioErrorType.sendTimeout:{
        return ErrorEntity(-1, "请求超时");
      }
      break;
      case DioErrorType.receiveTimeout:{
        return ErrorEntity(-1, "响应超时");
      }
      break;
      case DioErrorType.response:{
        try {
          int? errCode = error.response?.statusCode;
          String? errMsg = error.response?.statusMessage;
          return ErrorEntity(errCode, errMsg);
        } on Exception catch(_) {
          return ErrorEntity( -1,  "未知错误");
        }
      }
      break;
      default: {
        return ErrorEntity( -1, error.message);
      }
    }
  }

  /**
   * 取消请求
   * 同一个cancle token可以用于多个请求，当一个cancel token取消时，所有使用改CancleToken的请求都会给取消
   */
  void cancleRequests(CancelToken cancelToken){
    cancelToken.cancel();
  }
}

//定义回调
typedef ErrorCallBack = Function(ErrorEntity errorEntity);
typedef LoginCallBack = Function();
typedef SuccessData<T> = Function(T data);
typedef SuccessListData<T> = Function(List<T> dataList);
