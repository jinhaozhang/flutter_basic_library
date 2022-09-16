import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

extension widget_padding on Widget {
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);
}

/// Add margin property to widget
extension WidgetMarginX on Widget {
  Widget marginAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
          margin:
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
          margin: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);
}

/// Allows you to insert widgets inside a CustomScrollView
extension WidgetSliverBox on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}

extension WidgetSizeBos on Widget {
  Widget  sizeBox({double? width,double? height}) => SizedBox(child: this,height: height ?? 0,width: width ?? 0,);
}

extension WidgetGestureDetector on Widget {
  Widget  click(GestureTapCallback onTap,{GestureLongPressCallback? onLongPress}) => GestureDetector(child: this,onTap: onTap,onLongPress:onLongPress);
}

extension WidgetGestureDetector1 on Widget {
  Widget  clickDouble({GestureTapCallback? onTap,GestureLongPressCallback? onLongPress}) => GestureDetector(child: this,onTap: onTap,onLongPress:onLongPress);
}

extension WidgetGestureDetector2 on Widget {
  Widget  clickLong(GestureLongPressCallback onLongPress) => GestureDetector(child: this,onLongPress:onLongPress);
}

extension WidgetOffstage on Widget {
  Widget  isVisible({bool? isShow}) => Offstage(child: this,offstage: isShow ?? false);
}

extension WidgetOpacity on Widget {
  Widget  isOpacity({bool? isShow}) => Opacity(child: this,opacity: isShow! ? 0 : 1,);
}

extension BgContainerStyle on Widget {
  Widget  bgStyle({AlignmentGeometry? alignment,Color? bgColor,Radius? radius,EdgeInsets? margin,EdgeInsets? padding}) => Container(child: this,alignment:alignment ?? Alignment.topLeft,decoration: BoxDecoration(color:bgColor??Colors.white,borderRadius: BorderRadius.all(radius??const Radius.circular(10))),margin: margin??const EdgeInsets.all(10),padding:padding?? const EdgeInsets.all(10));
}

