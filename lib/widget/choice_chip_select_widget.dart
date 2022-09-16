import 'package:flutter/material.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';



abstract class BaseSelectEntity{
  String get getTag;///标签显示的内容

  bool isChoices=false;
  bool get isChoiced => isChoices;///是否被选中
  setChoiced(bool value)=>isChoices=value;///是否被选中
}

///自定义的多标签的多选组件  实体需要继承BaseSelectEntity
class PubChoiceChip<T extends BaseSelectEntity> extends StatefulWidget{

  /// 标签的list
  final List<T> dataList;
  
  int type;///0为单选 1为多选

  ///选择回调事件 返回的是选中的条目集合
  final Function(List<T>)? onSelectionChanged;

  ///默认的背景颜色
  Color? bgColor;

  ///选中的背景颜色
  Color? slecetColor;

  PubChoiceChip(this.dataList, this.type,{this.onSelectionChanged,this.bgColor,this.slecetColor});


  @override
  _PubChoiceChipState createState() => _PubChoiceChipState();
  
}

class _PubChoiceChipState<T extends BaseSelectEntity> extends State<PubChoiceChip>{


  _PubChoiceChipState();

  @override
  void initState() {
    super.initState();
    ///保证初始化的时候就回调符合要求的数据
    widget.onSelectionChanged!(widget.dataList.where((e) => e.isChoiced).toList());
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      spacing: 8,///子组件的左右间隙
      runSpacing: 5,///子组件的上下间隙
      // alignment: WrapAlignment.end,///子组件的开始方向
      children: _buildChoiceList(),
    );
  }
  _buildChoiceList() {
    List<Widget> choices =[];
    widget.dataList.forEach((item) {
      choices.add(ChoiceChip(
          label: Text(item.getTag),
          labelStyle:TextStyle(color: item.isChoiced ? Colors.white : Colors.black87,fontSize: 11.sp),
          selected:item.isChoiced,///选中的条件
          selectedColor:widget.slecetColor ?? ColorUtil(color_376EFF),///选中的背景颜色
          backgroundColor:widget.bgColor ?? ColorUtil(color_f3f6ff),///默认背景颜色
          // disabledColor: Colors.red,///不可用的颜色
          // selectedShadowColor:Colors.red,///选中的阴影背景色
          // shadowColor:Colors.red,///阴影背景色
          // shape: RoundedRectangleBorder(///默认是两端半圆形
          //   borderRadius: BorderRadius.circular(12),
          //   side:const BorderSide(color: Colors.black, width: 0.5),
          // ),
          // avatar:,///左侧Widget 一般小图标
          // padding: ,///设置为MaterialTapTargetSize.shrinkWrap时,clip距顶部距离为0；设置为MaterialTapTarget Size.padded时距顶部有一个距离
          // materialTapTargetSize: MaterialTapTargetSize.padded,///配置点击目标的最小大小
          materialTapTargetSize: MaterialTapTargetSize.padded,
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.w,top: 5.w),
          onSelected:(selected){
            setState(() {
              if(widget.type==0){
                widget.dataList.forEach((element) => element.setChoiced(false));
              }
              item.setChoiced(selected);
              widget.onSelectionChanged!(widget.dataList.where((e) => e.isChoiced).toList());
            });
          },
      ));
    });

    return choices;
  }
}
