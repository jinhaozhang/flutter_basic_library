
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library_example/db/tableConfig.dart';
import 'package:flutter_basic_library_example/net/interceptors_wrapper.dart';
import 'package:flutter_basic_library_example/tools/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class GloblConfig {
  /// 初始化
  static init() async {
    ///统一修改状态栏的颜色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      // 状态栏字体颜色（黑色）Brightness.light 状态栏字体颜色（白色）
      statusBarColor: Colors.white, // 状态栏背景色
    ));

    /// 初始化生命周期 监听
    WidgetsFlutterBinding.ensureInitialized();
    await initthirdparty();
  }

  static initthirdparty() async {
    router = FluroRouter();
    Routes.configureRoutes(router);

    /// 初始化数据库
    await DatabaseUtils().init(tables: TablesDemoConfig.getAllTables(),version:1,versionSql:{
      1:TablesDemoConfig.version_1_2,
      2:TablesDemoConfig.version_2_3
    });

    ///初始化shared_preferences
    // SpUtils.instance;

    ///文件工具初始化
    // FilesUtils.init();

    ///初始化原生的桥接工具
    // ChannelUtils.instance;

    ///添加rxdart的监听
    RxUtils.instance.addSubject('demo');

    ///初始化网络工具
    NetUtils.instance.init(headers: {'jxs-login-terminal':'ANDROID'},interceptor:MyInterceptorsWrapper());

    /// 配置通用 loading 时长
    EasyLoading.instance.displayDuration = const Duration(
      milliseconds: 2000,
    );
  }

}