import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/route_observer_util.dart';
import 'package:flutter_basic_library_example/mvvm/mvvm_demo.dart';
import 'package:flutter_basic_library_example/tools/globl_config.dart';
import 'package:flutter_basic_library_example/tools/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runZonedGuarded(() async {
    // 第三方初始化
    await GloblConfig.init();
    // runApp(MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => LoginViewModel()),
    //   ],
    //   child: MyApp(),
    // ));
    runApp(MyApp());
  }, (error, stackTrace) {
    if(kDebugMode){
      throw error;
    }
    callAliEmas(ApmLogType.E, error.toString());
    log(error.toString());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterBasicLibrary.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfigAll(
        child: MyMaterialApp(
                widget: DemoListPage(),
                navigatorObservers:[RouteUtils.instance],
                generator: router.generator,
                color:  ColorUtil(color_F3F5FC),
              ).getMaterIalApp(context)
    ).getConfig();

  }
}


/**
  * by zjh
  * 2022/9/15  9:05
  */
class DemoListPage extends StatefulWidget{

  @override
  _DemoListPageState createState()=>_DemoListPageState();

}

class _DemoListPageState extends State<DemoListPage>{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: getPublicAppBar(context, 'demo'),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ListTile(title: Text('数据库demo'),).click(() =>NavigatorUtil.jump(context, Routes.demoDbPage)),

          ListTile(title: Text('rxdart demo'),).click(() =>NavigatorUtil.jump(context, Routes.rxdartDemoPage)),

          ListTile(title: Text('mvvm demo'),).click(() =>NavigatorUtil.jump(context, Routes.mvvmDemoPage)),

        ],
      ),
    );
  }

}


