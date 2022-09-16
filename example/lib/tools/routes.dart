import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_library_example/db/demo_db.dart';
import 'package:flutter_basic_library_example/mvvm/mvvm_demo.dart';
import 'package:flutter_basic_library_example/rxdart/rxdart_demo.dart';


class Routes{
  static const String main="/";
  static const String demoDbPage = '/demoDbPage';
  static const String rxdartDemoPage='/rxdartDemoPage';
  static const String mvvmDemoPage='/mvvmDemoPage';

  static void configureRoutes(FluroRouter router) {
    // router.define(main, handler: mainPageHandler);
    router.define(demoDbPage, handler: demoDbPageHandler);
    router.define(rxdartDemoPage, handler: rxdartDemoPageHandler);
    router.define(mvvmDemoPage, handler: mvvmDemoPageHandler);
    // router.notFoundHandler =notFountPageHandler;     //空页
  }
}


var demoDbPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return DemoDbPage();
    });

var rxdartDemoPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return RxdartDemoPage();
    });

var mvvmDemoPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return MvvmDemoPage();
    });
