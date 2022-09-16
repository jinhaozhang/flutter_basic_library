import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';


extension size_extention on num {
  ///[YQScreenSizeUtils.setWidth]
  double get w => YQScreenSizeUtils().setWidth(this);

  ///[YQScreenSizeUtils.setHeight]
  double get h => YQScreenSizeUtils().setHeight(this);

  ///[YQScreenSizeUtils.radius]
  double get r => YQScreenSizeUtils().radius(this);

  ///[YQScreenSizeUtils.setSp]
  double get sp => YQScreenSizeUtils().setSp(this);

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get sm => min(toDouble(), sp);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => YQScreenSizeUtils().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => YQScreenSizeUtils().screenHeight * this;

  ///[YQScreenSizeUtils.setHeight]
  Widget get verticalSpace => YQScreenSizeUtils().setVerticalSpacing(this);

  ///[YQScreenSizeUtils.setVerticalSpacingFromWidth]
  Widget get verticalSpaceFromWidth =>
      YQScreenSizeUtils().setVerticalSpacingFromWidth(this);

  ///[YQScreenSizeUtils.setWidth]
  Widget get horizontalSpace => YQScreenSizeUtils().setHorizontalSpacing(this);

  ///[YQScreenSizeUtils.radius]
  Widget get horizontalSpaceRadius =>
      YQScreenSizeUtils().setHorizontalSpacingRadius(this);

  ///[YQScreenSizeUtils.radius]
  Widget get verticalSpacingRadius =>
      YQScreenSizeUtils().setVerticalSpacingRadius(this);
}

extension EdgeInsetsExtension on EdgeInsets {
  /// Creates adapt insets using r [SizeExtension].
  EdgeInsets get r =>
      copyWith(
        top: top.r,
        bottom: bottom.r,
        right: right.r,
        left: left.r,
      );
}

extension BorderRaduisExtension on BorderRadius {
  /// Creates adapt BorderRadius using r [SizeExtension].
  BorderRadius get r =>
      copyWith(
        bottomLeft: bottomLeft.r,
        bottomRight: bottomLeft.r,
        topLeft: topLeft.r,
        topRight: topRight.r,
      );
}

extension RaduisExtension on Radius {
  /// Creates adapt Radius using r [SizeExtension].
  Radius get r => Radius.elliptical(x.r, y.r);
}

extension BoxConstraintsExtension on BoxConstraints {
  /// Creates adapt BoxConstraints using r [SizeExtension].
  BoxConstraints get r =>
      this.copyWith(
        maxHeight: maxHeight.r,
        maxWidth: maxWidth.r,
        minHeight: minHeight.r,
        minWidth: minWidth.r,
      );

  /// Creates adapt BoxConstraints using h-w [SizeExtension].
  BoxConstraints get hw =>
      this.copyWith(
        maxHeight: maxHeight.h,
        maxWidth: maxWidth.w,
        minHeight: minHeight.h,
        minWidth: minWidth.w,
      );
}