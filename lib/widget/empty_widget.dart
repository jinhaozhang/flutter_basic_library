import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';

///统一的空页面
class EmptyPager extends StatefulWidget{

  EmptyPager({Key? key}) :super(key:key);

  @override
  State<StatefulWidget> createState() => EmptyPagerState();

}

class EmptyPagerState extends State<EmptyPager>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/img_empty.png',width: 120,height: 120,),
          const SizedBox(height: 20,),
          Text('暂无数据',style: TextStyle(color: ColorUtil(color_376EFF),fontSize: 14),)
        ],
      ),
    ).marginOnly(top: 180);
  }

}