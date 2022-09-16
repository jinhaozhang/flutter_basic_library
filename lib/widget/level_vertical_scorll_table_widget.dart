import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/color_utils.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';

///https://github.com/student9128/FlutterStudy/blob/main/lib/advanced/vh_scrollable_table_page.dart
class LevelVerticalScrollTablePage extends StatefulWidget {

  List<List<String>> data;
  Color? broColor;///线框的颜色
  Color? titleBgColor;///标题的背景色
  Color? bottomBgColor;///底部合计的背景色
  double? textSize;///字体的大小
  bool isFixed;///是否固定底部  默认不固定底部信息


  LevelVerticalScrollTablePage({required this.data,Key? key,this.broColor,this.bottomBgColor,this.titleBgColor,this.textSize,this.isFixed=false}) : super(key: key);

  @override
  _LevelVerticalScrollTablePageState createState() => _LevelVerticalScrollTablePageState();
}

class _LevelVerticalScrollTablePageState extends State<LevelVerticalScrollTablePage> {

  // List<List<String>> _data = [];
///每一列的数据包装为一个数组  如下列所示  直接传进来即可  注意每个数组的长度必须一致
  setData(){
    // widget.data=[];
    List<String> firstColumn = ['商品','北冰洋橙汁1北冰洋橙汁1北冰洋橙汁1北冰洋橙汁1789764654654654456','北冰洋橙汁2','北冰洋橙汁3','北冰洋橙汁4','北冰洋橙汁5','北冰洋橙汁6','北冰洋橙汁7','北冰洋橙汁8','北冰洋橙汁9','北冰洋橙汁10','北冰洋橙汁11','北冰洋橙汁12','合计'];
    List<String> secColumn = ['规格','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱','330ml*24*听/箱',''];
    List<String> threeColumn = ['订货数','1','2','3','4','5','6','7','8','9','10','11','12','33'];
    List<String> fourColumn = ['第一次发货\n2022年3月4日','1','2','3','4','5','6','7','8','9','10','11','12','34'];
    List<String> fiveColumn = ['第二次发货\n2022年3月4日','1','2','3','4','5','6','7','8','9','10','11','12','35'];
    List<String> fiveColumn3 = ['第三次发货\n2022年3月4日','1','2','3','4','5','6','7','8','9','10','11','12','35'];
    List<String> sixColumn = ['累计发货数','1','2','3','4','5','6','7','8','9','10','11','12','36'];
    List<String> sevenColumn = ['未发货数','1','2','3','4','5','6','7','8','9','10','11','12','37'];
    widget.data.add(firstColumn);
    widget.data.add(secColumn);
    widget.data.add(threeColumn);
    widget.data.add(fourColumn);
    widget.data.add(fiveColumn);
    widget.data.add(fiveColumn3);
    widget.data.add(sixColumn);
    widget.data.add(sevenColumn);
  }

  double _leftWidth = 100.w;
  double _cellWidth = 100.w;
  double _cellHeight = 60.w;
  final ScrollController _titleController = ScrollController();
  final ScrollController _bottomController = ScrollController();
  final ScrollController _contentController = ScrollController();

  fullScreenColoum(){
    if(widget.isFixed&&widget.data.isNotEmpty){
      if(13 - widget.data.first.length > 0){
        int index = 13 - widget.data.first.length;
        for(int i=0;i<index;i++){
          widget.data.forEach((element) {
            element.insert(element.length-1, '');
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    /// demo 假数据  放开 就能看到效果
    // setData();
    _titleController.addListener(_updateContent);
    _bottomController.addListener(_updateOther);
    _contentController.addListener(_updateTitle);
  }

  void _updateOther() {
    if (_titleController.offset != _bottomController.offset) {
      _titleController.jumpTo(_bottomController.offset);
    }
    if (_contentController.offset != _bottomController.offset) {
      _contentController.jumpTo(_bottomController.offset);
    }
  }

  void _updateTitle() {
    if (_titleController.offset != _contentController.offset) {
      _titleController.jumpTo(_contentController.offset);
    }
    if (_bottomController.offset != _contentController.offset) {
      _bottomController.jumpTo(_titleController.offset);
    }
  }

  void _updateContent() {
    if (_contentController.offset != _titleController.offset) {
      _contentController.jumpTo(_titleController.offset);
    }
    if (_bottomController.offset != _titleController.offset) {
      _bottomController.jumpTo(_titleController.offset);
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateContent);
    _contentController.removeListener(_updateTitle);
    _bottomController.removeListener(_updateOther);
    super.dispose();
  }

  ///顶部标题
  Container _buildTitleContainer(int i) {
    return Container(
      decoration: BoxDecoration(
          color: widget.titleBgColor ?? ColorUtil(color_0D376EFF),
          border: Border(
              bottom: _borderSide(),
              right: _borderSide())),
      alignment: Alignment.center,
      padding:  EdgeInsets.all(7.w),
      width: _cellWidth,
      height: _cellHeight,
      child: Text(
        widget.data[i].first,
        textAlign: TextAlign.center,
        style: TextStyle(color:  ColorUtil(color_333333),fontSize:widget.textSize?? 12.sp,fontWeight: FontWeight.w500),
      ),
    );
  }

  ///顶部标题
  _buildRightTitle() {
    List<Widget> list = [];
    for (int i = 1; i < widget.data.length; i++) {
      list.add(_buildTitleContainer(i));
    }
    return list;
  }

  _buildRightContent(int index) {
    List<Widget> list = [];
    for (int i = 1; i < widget.data.length; i++) {
      list.add(Container(
        alignment: Alignment.center,
        padding:  EdgeInsets.all(7.w),
        decoration:  BoxDecoration(
            color:widget.isFixed ? Colors.white : index == (widget.data[0].length-2) ?  widget.bottomBgColor ??ColorUtil(color_376EFF): Colors.white,
            border: Border(
                bottom: _borderSide(),
                right:_borderSide())),
        width: _cellWidth,
        height: _cellHeight,
        child: Text(
          widget.data[i][index+1],
          style: TextStyle(color:widget.isFixed ? ColorUtil(color_333333)  : index == widget.data[0].length-2 ? Colors.white:  ColorUtil(color_333333),fontSize: widget.textSize??12.sp),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    fullScreenColoum();
    return widget.data.isNotEmpty ? Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: widget.titleBgColor ?? ColorUtil(color_0D376EFF),
                  border: Border(
                      bottom: _borderSide(),
                      right:_borderSide())),
              width: _leftWidth,
              height: _cellHeight,
              alignment: Alignment.center,
              padding:  EdgeInsets.all(7.w),
              child: Text(widget.data.first.first, textAlign: TextAlign.center, style: TextStyle(color:  ColorUtil(color_333333),fontSize:widget.textSize?? 12.sp,fontWeight: FontWeight.w500)),
            ),
            Expanded(
                child: Container(
                  width: widget.data.length * _cellWidth,
                  child: SingleChildScrollView(
                    controller: _titleController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildRightTitle(),
                    ),
                  ),
                ))
          ],
        ),
        Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: _leftWidth,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding:  EdgeInsets.all(5.w),
                                  alignment:  Alignment.center,
                                  decoration:  BoxDecoration(
                                      color:widget.isFixed ?
                                      widget.titleBgColor ??ColorUtil(color_0D376EFF)
                                          :
                                      index == (widget.data.first.length-2) ? widget.bottomBgColor ??ColorUtil(color_376EFF):  widget.titleBgColor ??ColorUtil(color_0D376EFF),
                                      border: Border(
                                          bottom: _borderSide(),
                                          right: _borderSide())),
                                  width: _cellWidth,
                                  height: _cellHeight,
                                  child: widget.data.first[index + 1].text
                                      .maxFontSize(widget.textSize ?? 13)
                                      .minFontSize(9)
                                      .fontWeight(FontWeight.w500)
                                      .color(widget.isFixed ? ColorUtil(color_333333) : index == (widget.data.first.length-2) ? Colors.white:  ColorUtil(color_333333))
                                      .makeCentered(),
                                  // child: Text(widget.data.first[index+1],  textAlign: TextAlign.left,style: TextStyle(color: index == (widget.data.first.length-2) ? Colors.white:  ColorUtil(color_333333),fontSize:widget.textSize?? 12.sp)),
                                ));
                          },
                          itemCount:widget.isFixed ? widget.data.first.length-2 : widget.data.first.length-1,
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            controller: _contentController,
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: (widget.data.length-1) * _cellWidth,
                              child: ListView.builder(
                                itemCount:widget.isFixed ? widget.data.first.length-2 : widget.data.first.length-1,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                    },
                                    child: Row(
                                      children: _buildRightContent(index),
                                    ),
                                  );
                                },
                              ),
                              // ),
                            ),
                          )
                      )
                    ],
                  ),
                ],
              ),
            )
        ),
        Offstage(
          offstage: !widget.isFixed,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: widget.bottomBgColor ?? ColorUtil(color_376EFF),
                    border: Border(
                        bottom: _borderSide(),
                        right:_borderSide())),
                width: _leftWidth,
                height: _cellHeight,
                alignment: Alignment.center,
                padding:  EdgeInsets.all(7.w),
                child: Text(widget.data.first.last, textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize:widget.textSize?? 12.sp,fontWeight: FontWeight.w500)),
              ),
              Expanded(
                  child: Container(
                    width: widget.data.length * _cellWidth,
                    child: SingleChildScrollView(
                      controller: _bottomController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _buildBottomTitle(),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    ) : SizedBox();
  }

  ///顶部标题
  _buildBottomTitle() {
    List<Widget> list = [];
    for (int i = 1; i < widget.data.length; i++) {
      list.add(_buildBottomContainer(i));
    }
    return list;
  }

  ///顶部标题
  Container _buildBottomContainer(int i) {
    return Container(
      decoration: BoxDecoration(
          color: widget.bottomBgColor ?? ColorUtil(color_376EFF),
          border: Border(
              bottom: _borderSide(),
              right: _borderSide())),
      alignment: Alignment.center,
      padding:  EdgeInsets.all(7.w),
      width: _cellWidth,
      height: _cellHeight,
      child: Text(
        widget.data[i].last,
        textAlign: TextAlign.center,
        style: TextStyle(color:  Colors.white,fontSize:widget.textSize?? 12.sp,fontWeight: FontWeight.w500),
      ),
    );
  }

  BorderSide _borderSide()=>BorderSide(color: widget.broColor ?? ColorUtil(color_DADADA), width: 0.5.w);
}