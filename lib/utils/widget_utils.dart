import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/more_pickers/route/single_picker_route.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';
import 'package:flutter_basic_library/utils/navigator_util.dart';



///返回统一的标题样式
///goBack 是否自定义返回的方法；  title 页面的标题；  context 上下文 titleWidget自定义标题样式
AppBar getPublicAppBar(BuildContext context,String title,{double? elevation,VoidCallback? goBack,Color backgroundColor=Colors.white,bool isCenter=true,List<Widget>? actions ,Widget? titleWidget}){
  return AppBar(
    elevation: elevation ?? 1,
    backgroundColor: backgroundColor,
    leading: IconButton(icon: const Icon(Icons.arrow_back_ios_outlined,color: Colors.black87), onPressed: () {
      if(goBack==null){
        NavigatorUtil.goBack(context);
      }else{
        goBack();
      }
    }),
    centerTitle: isCenter,
    actions: actions ?? [],
    title: titleWidget ?? Text(title,style: TextStyle(color: Colors.black87,fontSize: 18.sp),),
  );
}

///两端为圆形的按钮 可带图标
///broColor 边框颜色 textColor字体颜色  broRadius圆角设置  默认为10  是否带有图标
MaterialButton getPubMaterialButton(String content,{VoidCallback? callback,Color? broColor,Color? textColor,double? broRadius,double? textSize,Key? key,Icon? icon,Color? bgColor,double? height,double? minWidth}){
  return MaterialButton(onPressed:callback,
      key: key ?? GlobalKey(),
      color: bgColor ?? Colors.white,///背景颜色
      elevation: 0,
      shape:  RoundedRectangleBorder( ///边框颜色
          side: BorderSide(color: broColor ?? Colors.black12,width: 0.5.w),
          borderRadius: BorderRadius.all(Radius.circular(broRadius ?? 10.r))),
      height:height ??  20.h,
      minWidth: minWidth ?? 60.w,
      child:Row(
        children:  [
          Text(content,style: TextStyle(color:textColor ?? ColorUtil(color_333333),fontSize: textSize ?? 14.sp ),),
          getIconWidget(icon),
        ],
      )
  );
}

Widget getIconWidget(Icon? icon){
  if(icon == null){
    return const SizedBox();
  }else{
    return icon;
  }
}


///带有边框的显示Text
///broColor 边框颜色 textColor字体颜色 content内容 borderRadius圆角 textSize字体大小 paddingLR左右间距 paddingTB上下间距 broWidthb边框宽度 bgColor背景颜色
Widget getPubText(String content,{TextDecoration? decoration,FontWeight? fontWeight,Color? broColor,Color? textColor,double? borderRadius,double? textSize,double? paddingLR,double? paddingTB,double? broWidth,Color? bgColor,
  double? marginL,double? marginR,double? marginT,double? marginB,TextAlign? textAlign}){
  return Container(
    child: Text(content,
      // textDirection: TextDirection.ltr,
      maxLines: 3,
      textAlign: textAlign??TextAlign.left,
      softWrap: true,
      overflow:TextOverflow.ellipsis,///clip【截取】，fade【隐藏】，ellipsis【三点省略】，visible【不换行】
      style: TextStyle(decoration:decoration ?? TextDecoration.none,fontWeight:fontWeight ?? FontWeight.normal,color: textColor ?? ColorUtil(color_333333),fontSize: textSize ?? 14.sp),),
    padding: EdgeInsets.only(left: paddingLR ?? 5.w,right: paddingLR ?? 5.w,top: paddingTB ?? 3.w,bottom:paddingTB ?? 3.w),
    margin: EdgeInsets.only(left: marginL ?? 0,right: marginR ?? 0,top: marginT ?? 0,bottom:marginB ?? 0),
    decoration: BoxDecoration(
      color: bgColor ?? Colors.white,
      border: Border.all(
        width: broWidth ?? 0.5.w,
        color:broColor ?? Colors.white,
      ),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 2.r))
    ),
  );
}


Widget getPubTextField({String? defalutValue,TextInputType? textInputType,int? maxLength,String? hintDesc,Icon? rightIcon,bool isRightIcon=false,bool autofocus=false,ValueChanged<String>? onChanged}){
  FocusNode focusNode =  FocusNode();
  TextEditingController _controller = TextEditingController(text: defalutValue);
  return Expanded(child: TextField(///https://zhuanlan.zhihu.com/p/483091480
    ///cursorColor: Colors.red,///设置光标的样式
    ///   cursorRadius: Radius.circular(16.0),
    ///   cursorWidth: 16.0,
    textInputAction:TextInputAction.done,
    minLines: 1,
    maxLines: 5,
    // maxLength: maxLength??,
    textAlign: TextAlign.right,
    // readOnly: true,///禁止弹窗系统键盘，然后再显示自定义键盘禁用很简单，设置两个属性即可
    // showCursor: true,///禁止弹窗系统键盘，然后再显示自定义键盘禁用很简单，设置两个属性即可
    autofocus: autofocus,///是否自动获取焦点和键盘 默认不自动获取
    style: TextStyle(color: ColorUtil(color_333333),fontSize: 14.sp),
    focusNode:focusNode,//用于控制TextField是否占有当前键盘的输入焦点。它是我们和键盘交互的一个句柄（handle）
    onEditingComplete:(){

    },///输入完成回调 主要配合TextInputAction.done使用
    onSubmitted:(value){
      focusNode.unfocus();
      // widget!.onBackCall!(key);
    },///提交 配合TextInputAction  文字提交触发（键盘按键）
    controller:_controller,
    decoration: InputDecoration(///用于控制TextField的外观显示，如提示文本、背景颜色、边框等
      /// fillColor:ColorUtil(color_F3F5FC),//背景颜色
      //filled: true,//重点，必须设置为true，fillColor才有效
      //isCollapsed: true,//重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
      contentPadding:const EdgeInsets.symmetric(horizontal: 1, vertical: 1),//内容内边距，影响高度
      border: InputBorder.none,
      hintText: hintDesc!,
      // suffixIcon:Offstage(
      //   offstage:isRightIcon,///默认显示右侧图标
      //   child: IconButton(icon: rightIcon ?? Icon(Icons.cancel,color: ColorUtil(color_9092A5),),onPressed: (){
      //     // focusNode.unfocus(); /// 当所有编辑框都失去焦点时键盘就会收起
      //     _controller!.clear();
      //   },),
      // ),
    ),

  //   TextInputType.text（普通完整键盘）
  //   TextInputType.number（数字键盘）
  // TextInputType.emailAddress（带有“@”的普通键盘）
  // TextInputType.datetime（带有“/”和“:”的数字键盘）
  // TextInputType.numberWithOptions（带有启用有符号和十进制模式选项的数字键盘）
  // TextInputType.multiline（多行信息优化）

    keyboardType: textInputType ?? TextInputType.text,///用于设置该输入框默认的键盘输入类型
    onChanged:(text){
      onChanged!(text);
    },
  ));
}

///https://blog.csdn.net/ulddfhv/article/details/125303798
TextButton getPubTextButton(String content,{VoidCallback? onPressed,Color? borColor,Color? bgColor,Color? textColor,double? textSize,}){
  return TextButton(onPressed: onPressed, child: Text(content,style: TextStyle(color:textColor ?? ColorUtil(color_333333),fontSize: textSize ?? 14.sp),),
      style: ButtonStyle(
      //设置按钮内边距
      padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(15.w, 5.w, 15.w, 5.w)),
      // shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      //边框
      side: MaterialStateProperty.all( BorderSide(color: borColor ?? ColorUtil(color_666666), width: 1.w)),
      //背景
      backgroundColor:MaterialStateProperty.all(bgColor ?? Colors.white),
        //   backgroundColor: MaterialStateProperty.resolveWith((states) {
        //     //设置按下时的背景颜色
        //     if (states.contains(MaterialState.pressed)) {
        //       return Colors.blue[200];
        //     }
        //     //默认不使用背景颜色
        //     return null;
        //   })),
      //设置按钮的大小
      minimumSize: MaterialStateProperty.all(Size(80.w, 30.w)),
      //外边框装饰 会覆盖 side 配置的样式
      shape: MaterialStateProperty.all(const StadiumBorder()),
    ),
  );
}

Row getTextIcon(String text,{IconData? icon,TextStyle? style,Color? colorIcon}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text,style: style ?? TextStyle(color: ColorUtil(color_666666),fontSize: 14.sp)),
      Icon(icon ?? Icons.chevron_right,color: colorIcon??Colors.black87)
    ],
  );
}

Row getTextImage(String text,String imagePath,{TextStyle? style,Color? colorIcon}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text,style: style ?? TextStyle(color: ColorUtil(color_666666),fontSize: 14.sp)),
      const SizedBox(width: 10,),
      Image.asset(imagePath ,width: 30,height: 30,)
    ],
  );
}

Widget getMarkImage({String? imgUrl,String? markImgurl,double? width,double? height,double? widthMark,double? heightMark}){
  return Stack(
    children: [
      ImageLoadWidget(imgUrl: imgUrl,width: 70.w,height: 70.w),
      Image.asset(markImgurl!,height: widthMark??25.w,width: heightMark??35.w,),
    ],
  );
}

Widget commonButtonWidget(
      {String txt= "弹出",
      Color fontcolor= const Color(0xFF19D88E),
      Color? backcolor,
      double? fontsize=18,
      Function? ontap}) {
  Color backcolor = const Color(0xFF19D88E).withOpacity(0.2);
  return Center(
    child: Material(
//INK可以实现装饰容器
      child: Ink(
        //用ink圆角矩形

        decoration: BoxDecoration(
          //不能同时”使用Ink的变量color属性以及decoration属性，两个只能存在一个
          color: backcolor,
          //设置圆角
          borderRadius:const BorderRadius.all(Radius.circular(25.0)),
        ),
        child: InkWell(
          //圆角设置,给水波纹也设置同样的圆角
          //如果这里不设置就会出现矩形的水波纹效果
          borderRadius: BorderRadius.circular(25.0),
          //设置点击事件回调
          onTap: () {
            ontap!();
          },
          child: Container(
            width: 300.0,
            height: 36.0,
            //设置child 居中
            alignment:const Alignment(0, 0),
            child: Text(
              txt,
              style: TextStyle(color: fontcolor, fontSize: fontsize),
            ),
          ),
        ),
      ),
    ),
  );
}

///显示单选择框
showDateSingle(BuildContext context,var data, var selectData,{String? label,SingleCallback? onConfirm}){
  Pickers.showSinglePicker(
    context,
    data: data,
    pickerStyle: DefaultPickerStyle(haveRadius: true),
    selectData: selectData,
    suffix: label,
    onConfirm: onConfirm,
  );
}

///双时间选择的方法
showDoubleDateTimeBottomSheet(BuildContext context,DoubleValueChanged onDoubleValueBack){
  //用于在底部打开弹框的效果
  showModalBottomSheet(
      isScrollControlled: true,
      builder: (BuildContext context) {
        //构建弹框中的内容
        return DoubleDateChancedPager((value1, value2) {
          onDoubleValueBack(value1,value2);
        });
      },
      backgroundColor: Colors.transparent,//重要
      context: context);
}


showCupertinoAlertDialog(BuildContext context,String content,VoidCallback sureCallBack,{String? title,}){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title??'提示'),
          content: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Align(
                child: Text(content),
                alignment:const Alignment(0, 0),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child:const Text("取消"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child:const Text("确定"),
              onPressed: () {
                sureCallBack();
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}