import 'package:flutter/material.dart';
import 'package:flutter_basic_library/utils/changeLocalizations_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

///全局的状态标识   便于获取context
GlobalKey<NavigatorState> globalAppKey = GlobalKey<NavigatorState>();

class MyMaterialApp{

  ///路由监听
  List<NavigatorObserver>? navigatorObservers;

  ///路由页面信息
  RouteFactory? generator;

  ///页面色值
  Color? color;

  ///主界面组件
  Widget? widget;

  ///导航主题色样式
  ThemeData? themeData;

  MyMaterialApp({required  this.widget,this.navigatorObservers,this.generator,this.color,this.themeData});

  Widget getMaterIalApp(BuildContext context){
    return MaterialApp(
      navigatorObservers: navigatorObservers!,
      navigatorKey: globalAppKey,
      onGenerateRoute:generator,
      color: color,
      builder: EasyLoading.init(builder: (ctx, child) {
        final size = MediaQuery.of(ctx).size;
        YQScreenSizeUtils.init(ctx,
            designSize: Size(375, size.height * 375 / size.width));
        return child!;
      }),
      theme: themeData,
      debugShowCheckedModeBanner: false,
      ///本地化委托，用于更改Flutter Widget默认的提示语，按钮text等
      ///通常我们新建的 Flutter 应用是默认不支持多语言的，即使用户在中文环境下，显示的文字仍然是英文
      localizationsDelegates: [
        ///初始化默认的 Material 组件本地化
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ///初始化默认的 通用 Widget 组件本地化
        GlobalWidgetsLocalizations.delegate,
        ///初始化自定义多语言环境运行
        MyLocalizationsDelegates.delegate,
      ],
      ///当前区域，如果为null则使用系统区域一般用于语言切换
      ///传入两个参数，语言代码，国家代码
      ///这里配制为中国
      locale:const Locale('zh', 'CN'),
      ///传入支持的语种数组
      supportedLocales: const [
        Locale('en', 'US'), /// English 英文
        Locale('zh', 'CN'), /// 中文，后面的countryCode暂时不指定
      ],
      ///当传入的是不支持的语种，可以根据这个回调，返回相近,并且支持的语种
      localeResolutionCallback: (local, support) {
        ///当前软件支行的语言 也就是[supportedLocales] 中配制的语种
        if (support.contains(local)) {
          // log('support  $local');
          return local;
        }
        ///如果当前软件运行的手机环境不在 [supportedLocales] 中配制的语种范围内
        ///返回一种默认的语言环境，这里使用的是中文
        return const Locale('zh', 'CN');
      },
      home: Builder(builder: (context){
        return ChangeLocalizations(
          key: changeLocalizationStateKey,
          child: widget,
        );
      }),
      // home: widget.page
    );
  }

}