import 'package:flutter/material.dart';
import 'package:flutter_pickers/more_pickers/route/single_picker_route.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';

abstract class BaseSinglePicker{
  String  getShwoData();
}
///显示单选择框
showSinglePicker<T extends BaseSinglePicker>(BuildContext context,List<T> data, T selectData,{String? label,SingleCallback? onConfirm}){
  List<String>  listData =[];
  String defaultStr = selectData.getShwoData();
  data.forEach((element) {
    listData.add(element.getShwoData());
  });
  DefaultPickerStyle defaultPickerStyle = DefaultPickerStyle(haveRadius: true);
  defaultPickerStyle.commitButton = Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(left: 12, right: 22),
    child:  Text('确定', style: TextStyle(color:  ColorUtil(color_376EFF), fontSize: 16.0)),
  );;
  Pickers.showSinglePicker(
    context,
    data: listData,
    pickerStyle: defaultPickerStyle,
    selectData: defaultStr,
    suffix: label,
    onConfirm:onConfirm
    ,
  );
}