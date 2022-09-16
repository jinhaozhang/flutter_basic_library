import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';
import 'package:flutter_basic_library/utils/navigator_util.dart';
import 'package:date_format/date_format.dart';


typedef DoubleValueChanged = void Function(DateTime value1,DateTime value2);

class DoubleDateChancedPager extends StatefulWidget{

  DoubleValueChanged? onDoubleValueBack;

  DateTime? startTime;///设置默认的开始时间
  DateTime? endTime;///设置默认的截至时间

  DateTime? startByTime;///设置开始时间的范围  默认前20年
  DateTime? endByTime;///设置截至时间的范围    默认截至到当前时间

  DoubleDateChancedPager(this.onDoubleValueBack,{this.startTime,this.endTime,this.startByTime,this.endByTime});

  @override
  State<StatefulWidget> createState() => DoubleDateChancedPagerState();

}

class DoubleDateChancedPagerState extends State<DoubleDateChancedPager>{

  bool isStart=true;
  bool isEnd=false;
  DateTime? nowTime;
  List<int> year = [];
  List<int> month = [];
  List<int> day = [];

  int? defaultMonth;
  int? defaultYear;
  int? defaultDay;

  DateTime? startTime;///开始时间
  DateTime? endTime;///截至时间


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nowTime = DateTime.now();
    defaultYear =nowTime!.year;
    defaultMonth =nowTime!.month;
    defaultDay =nowTime!.day;
    if(widget.endByTime==null){
      widget.endByTime=nowTime;
    }

    if(widget.endByTime != null && widget.endByTime!.year > nowTime!.year){
      for(var i=(widget.endByTime!.year-nowTime!.year); i > 0 ; i--  ){
        year.add(nowTime!.year + i);
      }
    }

    for(var i=0; i <= ((widget.startByTime !=null && widget.startByTime!.year < nowTime!.year) ? (nowTime!.year - widget.startByTime!.year) : 20) ; i++  ){
      year.add(nowTime!.year - i);
    }

    if(widget.startTime !=null ){
      startTime=widget.startTime;
      defaultYear =widget.startTime!.year;
      defaultMonth =widget.startTime!.month;
      defaultDay =widget.startTime!.day;
    }else{
      startTime= DateTime.now();
    }
    if(widget.endTime !=null ){
      endTime=widget.endTime;
    }else{
      endTime= DateTime.now();
    }
    getMonthAndDayData();
  }

  getMonthAndDayData(){
    setState(() {
      ///获取指定时间的月数
      month.clear();
      if(widget.endByTime != null && defaultYear == widget.endByTime!.year){
        for(var i=1; i <= widget.endByTime!.month ; i++  ){
          month.add(i);
        }
      }else if(widget.startByTime != null && defaultYear == widget.startByTime!.year){
        for(var i=1; i <= widget.startByTime!.month ; i++  ){
          month.add(i);
        }
      }else{
        month = [1,2,3,4,5,6,7,8,9,10,11,12];
      }
      ///获取指定时间的天数
      int days = DateTime(defaultYear!,defaultMonth!+1,0).day;
      // if(widget!.startByTime != null && defaultYear == widget!.startByTime!.year && defaultMonth == widget!.startByTime!.month){
      //   days =  widget!.startByTime!.day;
      // }
      // if(widget!.endByTime != null && defaultYear == widget!.endByTime!.year && defaultMonth == widget!.endByTime!.month){
      //   days =  widget!.startByTime!.day;
      // }
      day.clear();
      for(var i=1; i <= days ; i++  ){
        day.add(i);
      }
      if(defaultDay! > day[day.length-1]){
        defaultDay = day[day.length-1];
      }
    });
  }

  setStartStatus(int type){
    if(type==0&&!isStart){
      isStart=true;
      isEnd=false;
      defaultYear =startTime!.year;
      defaultMonth =startTime!.month;
      defaultDay =startTime!.day;
    }
    if(type==1&&!isEnd){
      isEnd=true;
      isStart=false;
      defaultYear =endTime!.year;
      defaultMonth =endTime!.month;
      defaultDay =endTime!.day;
    }
    getMonthAndDayData();
  }

  ///确认时间的方法
  sureDate(){
    if(startTime!.millisecondsSinceEpoch > endTime!.millisecondsSinceEpoch ){
      EasyLoading.showToast('截至时间不能小于开始时间！',duration:const Duration(seconds: 2));
    }else{
      widget.onDoubleValueBack!(startTime!,endTime!);
      NavigatorUtil.goBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 280.w,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),topRight: Radius.circular(10.r) )),
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(child: Text('取消',style:  TextStyle(fontSize: 16.sp),),onTap: ()=> NavigatorUtil.goBack(context),),
              GestureDetector(child: Text('确认',style: TextStyle(fontSize: 16.sp,color: ColorUtil(color_376EFF)),),onTap: ()=>sureDate(),),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Expanded(child: GestureDetector(child: Center(child: Column(children: [
                Text('开始时间',style: TextStyle(color:ColorUtil(color_333333) ,fontSize: 14.sp),),
                SizedBox(height: 7.w,),
                Text(formatDate(startTime!,TimeUitls.yyyy_MM_dd),style: TextStyle(color: isStart ? ColorUtil(color_376EFF) : ColorUtil(color_333333),fontSize: 15.sp)),
              ],),),onTap: ()=>setStartStatus(0),)),
              Expanded(child: GestureDetector(child: Center(child: Column(children: [
                Text('截至时间',style: TextStyle(color: ColorUtil(color_333333),fontSize: 14.sp),),
                SizedBox(height: 7.w,),
                Text(formatDate(endTime!,TimeUitls.yyyy_MM_dd),style: TextStyle(color: isEnd ? ColorUtil(color_376EFF) : ColorUtil(color_333333),fontSize: 15.sp)),
              ],),),onTap:()=>setStartStatus(1),)),
            ],
          ),
          SizedBox(height: 10.w,),
          Container(height: 1.w,  decoration: BoxDecoration(color: ColorUtil(color_9092A5),),),
          SizedBox(height: 9.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getData(year,0),
              getData(month,1),
              getData(day, 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget getData(List<int> data,int type){
    return Expanded(
      child:Container(
        height: 140.w,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem:getSelectIndex(data,type)),///设置默认值
          // diameterRatio: 1.5,///直径比，double类型
          // offAxisFraction: 0.2, //轴偏离系数  轴偏移，默认是0.0。控制选中的子widget的左右偏移
          // useMagnifier: true, //使用放大镜 默认false。
          // magnification: 1.5, //当前选中item放大倍数useMagnifier为true才管用
          // squeeze:0.7,///压缩，这个控制的children之间的空隙，和diameterRatio的效果有相似之处。
          itemExtent: 32, //行高
          // backgroundColor: Colors.white, ///选中器背景色
          selectionOverlay:Container(decoration:const BoxDecoration(color: Colors.transparent),),
          onSelectedItemChanged:(value){
            getItemValue(type,value);
          },
          children: getItemData(data,type),
        ),
      ),
    );
  }

  int getSelectIndex(List<int> data,int type){
    if(type==0){
      return data.indexOf(defaultYear!);
    }else if(type==1){
      return data.indexOf(defaultMonth!);
    }else{
      return day.indexOf(defaultDay!);
    }
  }

  List<Widget> getItemData(List<int> data,int type){
    List<Widget> widgets =[];
    data.forEach((element) {
      widgets.add(Container(
        margin:  EdgeInsets.only(top: 3.w,bottom: 3.w),
        child: Text(getItemShow(element,type),style: TextStyle(color:ColorUtil(color_333333) ,fontSize: 16.sp),),
      ));
    });
    return widgets;
  }

  String getItemShow(int value,int type){
    if(type==0){
      return '$value年';
    }else if(type==1){
      return '$value月';
    }else{
      return '$value日';
    }
  }

   getItemValue(int type,int index){
    if(type==0){
       defaultYear = year[index];
    }else if(type==1){
       defaultMonth = month[index];
    }else{
      if(index < day.length){
        defaultDay = day[index];
      }else{
        defaultDay=day[day.length-1];
      }
    }
    if(isStart){
      // startTime='$defaultYear-$defaultMonth-$defaultDay';
      startTime = DateTime(defaultYear!,defaultMonth!,defaultDay!);
    }
    if(isEnd){
      // endTime='$defaultYear-$defaultMonth-$defaultDay';
      endTime = DateTime(defaultYear!,defaultMonth!,defaultDay!);
    }
    getMonthAndDayData();
  }

}