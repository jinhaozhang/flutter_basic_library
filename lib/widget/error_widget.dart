import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';


typedef CallBack = Function();

///统一的网络错误页面
class NetErrorPager extends StatefulWidget{

  VoidCallback? callBack;

  NetErrorPager({Key? key,this.callBack}) :super(key:key);

  @override
  State<StatefulWidget> createState() => NetErrorPagerState();

}

class NetErrorPagerState extends State<NetErrorPager>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: [
          Image.asset('images/img_network.png',width: 120,height: 120,),
          const SizedBox(height: 20,),
          Text('网络错误！',style: TextStyle(color: ColorUtil(color_376EFF),fontSize: 14),),
          const SizedBox(height: 20,),
          GestureDetector(child:  Text('点击重新加载！',style: TextStyle(color: ColorUtil(color_376EFF),fontSize: 16),),onTap: (){
            widget.callBack!();
          },),
        ],
      ),
    ).marginOnly(top: 180);
  }

}