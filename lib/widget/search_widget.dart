import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';

///公共搜索框
class SearchWiget extends StatefulWidget{

  ValueChanged<String>? onBackCall;
  String hintDesc;
  bool autofocus;///是否自动获取焦点 弹起键盘 默认不获取
  Color? bgColor;

  SearchWiget({this.onBackCall,this.hintDesc='',this.autofocus=false,this.bgColor});

  @override
  State<StatefulWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWiget>{


  String key='';
  FocusNode focusNode =  FocusNode();
  TextEditingController? _textcontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 40.w,
      width: double.infinity,
      padding:  EdgeInsets.only(left: 10.w,right: 1.w),
      margin:  EdgeInsets.only(left: 15.w,right: 15.w,top: 8.w,bottom: 8.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)),color: widget.bgColor ?? Colors.white),
      child: TextField(///https://www.jianshu.com/p/e7968777e9f1
        // readOnly: true,///禁止弹窗系统键盘，然后再显示自定义键盘禁用很简单，设置两个属性即可
        // showCursor: true,///禁止弹窗系统键盘，然后再显示自定义键盘禁用很简单，设置两个属性即可
        autofocus: widget.autofocus,///是否自动获取焦点和键盘
        style: TextStyle(color: ColorUtil(color_333333),fontSize: 14.sp),
        focusNode:focusNode,//用于控制TextField是否占有当前键盘的输入焦点。它是我们和键盘交互的一个句柄（handle）
        onEditingComplete:(){

        },///输入完成回调 主要配合TextInputAction.done使用
        textInputAction: TextInputAction.search,///对应的键盘上的按键
        // textAlign: TextAlign.center,
        onSubmitted:(value){
          focusNode.unfocus();
          widget.onBackCall!(key);
        },///提交 配合TextInputAction  文字提交触发（键盘按键）
        controller:_textcontroller,
        decoration: InputDecoration(///用于控制TextField的外观显示，如提示文本、背景颜色、边框等
          fillColor: Colors.transparent,//背景颜色
          filled: true,//重点，必须设置为true，fillColor才有效
          //isCollapsed: true,//重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
          //contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响高度
          border: InputBorder.none,
          hintText: widget.hintDesc,
          prefixIcon:  Icon(Icons.search,size: 20,),//添加内部左边图标
          prefixIconConstraints: BoxConstraints(
            //添加内部图标之后，图标和文字会有间距，实现这个方法，不用写任何参数即可解决
          ),
          suffixIcon:Offstage(
            offstage: key.isEmpty,
            child: IconButton(icon: Icon(Icons.cancel,color: ColorUtil(color_9092A5),),onPressed: (){
              // focusNode.unfocus(); /// 当所有编辑框都失去焦点时键盘就会收起
              key='';
              _textcontroller!.clear();
              widget.onBackCall!(key);
            },),
          ),
          suffixIconConstraints: BoxConstraints(
            //添加内部图标之后，图标和文字会有间距，实现这个方法，不用写任何参数即可解决
          ),
        ),
        keyboardType: TextInputType.text,///用于设置该输入框默认的键盘输入类型
        onChanged:(text){
          key=text;
          setState(() {
            if(key.isEmpty){
              widget.onBackCall!(key);
            }
          });
        },
      ),
    );
  }

}