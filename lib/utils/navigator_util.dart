import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

late FluroRouter router;
/**
 * 这个里面主要是进行路由跳转方法的公共书写
 */
///https://www.cnblogs.com/woaixingxing/p/15930673.html
///https://juejin.cn/post/6873084082553782286
class NavigatorUtil {
  // 返回
  static void goBack(BuildContext context) {
    /// 其实这边调用的是 Navigator.pop(context);
    router.pop(context);
  }

  // 带参数的返回
  static void goBackWithParams(BuildContext context, result) {
    Navigator.pop(context, result);
  }

  // 路由返回指定页面
  static void goBackUrl(BuildContext context, String title) {
    Navigator.popAndPushNamed(context, title);
  }

  // 跳转到主页面
  // static void goIndexPage(BuildContext context) {
  //   router.navigateTo(context, Routes.main, replace: true);
  // }

  /// 跳转到 转场动画 页面 ， 这边只展示 inFromLeft ，剩下的自己去尝试下，
  /// 框架自带的有 native，nativeModal，inFromLeft，inFromRight，inFromBottom，fadeIn，custom
  /// clearStack 清空当前的路由 跳转新界面
  /// replace 替换当前的界面
  ///  bool maintainState = true,主界面
  ///  rootNavigator = false, 根目录
  static Future jump(BuildContext context, String title,{Map<String,dynamic>? params,bool clearStack=false,bool replace=false,bool rootNavigator=false,bool maintainState=true}) {
    if(params==null){
      return router.navigateTo(context, title,transition: TransitionType.inFromRight,clearStack: clearStack,replace: replace,
        maintainState: maintainState,rootNavigator: rootNavigator,);
    }else{
      String query =  "";
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
      return router.navigateTo(context, title+query,clearStack: clearStack,replace: replace,rootNavigator: rootNavigator,
          maintainState: maintainState,routeSettings: RouteSettings(arguments: params), transition: TransitionType.inFromRight);
    }


    /// 指定了 转场动画
  }

  /// 框架自带的有 native，nativeModal，inFromLeft，inFromRight，inFromBottom，fadeIn，custom
  static Future jumpLeft(BuildContext context, String title) {
    return router
        .navigateTo(context, title, transition: TransitionType.inFromLeft);

    /// 指定了 转场动画
  }

  // static Future jumpRemove(BuildContext context) {
  //   return Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         // builder: (context) => MainPager(),
  //         builder: (context) => AndroidConnectPage(),
  //       ),
  //           (route) => route == null);
  // }

  /// 自定义 转场动画
  static Future gotransitionCustomDemoPage(BuildContext context, String title) {
    var transition = (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return new ScaleTransition(
        scale: animation,
        child: new RotationTransition(
          turns: animation,
          child: child,
        ),
      );
    };
    return router.navigateTo(context, title,
        transition: TransitionType.custom,

        /// 指定是自定义动画
        transitionBuilder: transition,

        /// 自定义的动画
        transitionDuration: const Duration(milliseconds: 500));

    /// 时间
  }

  /// 使用 IOS 的 Cupertino 的转场动画，这个是修改了源码的 转场动画
  /// Fluro本身不带，但是 Flutter自带
  static Future gotransitionCupertinoDemoPage(
      BuildContext context, String title) {
    return router
        .navigateTo(context, title, transition: TransitionType.cupertino);
  }

  // 跳转到主页面IndexPage并删除当前路由
  // static void goToHomeRemovePage(BuildContext context) {
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         // builder: (context) => MainPager(),
  //         builder: (context) => AndroidConnectPage(),
  //       ),
  //           (route) => route == null);
  // }

  // 跳转到登录页并删除当前路由
  // static void goToLoginRemovePage(BuildContext context) {
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) => LoginPager(),
  //       ),
  //           (route) => route == null);
  // }
}


class FluroConvertUtils {

  /// fluro 传递中文参数前，先转换，fluro 不支持中文传递

  static String fluroCnParamsEncode(String originalCn) {

    return jsonEncode(const Utf8Encoder().convert(originalCn));

  }

  /// fluro 传递后取出参数，解析

  static String fluroCnParamsDecode(String encodeCn) {

    var list = <int>[];

    ///字符串解码

    jsonDecode(encodeCn).forEach(list.add);

    String value = const Utf8Decoder().convert(list);

    return value;

  }

  /// string 转为 int

  static int string2int(String str) {

    return int.parse(str);

  }

  /// string 转为 double

  static double string2double(String str) {

    return double.parse(str);

  }

  /// string 转为 bool

  static bool string2bool(String str) {

    if (str == 'true') {

      return true;

    } else {

      return false;

    }

  }

  /// object 转为 string json

  static String object2string<T>(T t) {

    return fluroCnParamsEncode(jsonEncode(t));

  }

  /// string json 转为 map

  static Map<String, dynamic> string2map(String str) {

    return json.decode(fluroCnParamsDecode(str));

  }

}

