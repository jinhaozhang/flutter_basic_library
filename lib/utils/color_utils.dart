import 'package:flutter/material.dart';

class ColorUtil extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  ColorUtil(final String hexColor) : super(_getColorFromHex(hexColor));
}

const  String color_appPrimary='#376EFF';

const  String color_37A274='#37A274';/// 绿色
const  String color_999999='#999999';
const  String color_333333='#333333';
const  String color_9092A5='#9092A5';
const  String color_666666='#666666';
const  String color_FF5E47='#FF5E47';/// 橙色
const  String color_F3F5FC='#F3F5FC';///背景色
const  String color_376EFF='#376EFF';/// 蓝色
const  String color_0D376EFF='#0D376EFF';/// 5%蓝色
const  String color_ff5A00='#FF5A00';/// 浅  橙色
const  String color_ff5A00_10='#1AF7B500';
const  String color_838CA8='#838CA8';
const  String color_1aff1f00='#1AFF1F00';///10%的透明度
const  String color_f3f6ff='#f3f6ff';
const  String color_ff5635='#ff5635';/// 有一个 橙色
const  String color_black_60='#99000000';
const  String color_ffa500='#FFA500';/// 又一个橙色
const  String color_99E0E0E0='#99E0E0E0';///
const  String color_1AFF9B00='#1AFF9B00';
const  String color_9A5F38='#9A5F38';/// 棕色
const  String color_DADADA='#DADADA';
