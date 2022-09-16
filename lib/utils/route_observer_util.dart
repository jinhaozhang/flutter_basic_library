import 'package:flutter/material.dart';


String? rootRouteName;///用于记录原生跳转到flutter的首个页面的路由名称

class RouteUtils extends NavigatorObserver{

  static final RouteUtils instance = RouteUtils._internal();
  factory RouteUtils() => instance;

  RouteUtils._internal();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('didPush route: $route,previousRoute:$previousRoute');
    // appIsCancleFlutter(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('didPop route: $route,previousRoute:$previousRoute');
    // appIsCancleFlutter(previousRoute!);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('didReplace newRoute: $newRoute,oldRoute:$oldRoute');
  }

  @override
  void didRemove(Route? route, Route? previousRoute) {
    super.didRemove(route!, previousRoute);
    print('didRemove route: $route,previousRoute:$previousRoute');
  }

  @override
  void didStartUserGesture(Route? route, Route? previousRoute) {
    super.didStartUserGesture(route!, previousRoute);
    print('didStartUserGesture route: $route,previousRoute:$previousRoute');
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    print('didStopUserGesture');
  }

}
