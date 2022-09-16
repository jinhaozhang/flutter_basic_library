import 'package:flutter/material.dart';

typedef ClickCallback = void Function(int selectIndex,String selectString);



const double cellHeight = 50.0;
const double spaceHeight = 5.0;
const Color spaceColor = Color(0xFF376EFF);//230

const Color textColor = Color(0xFF323232);//50
const double textFontSize = 15.0;

const Color redTextColor = 	Color(0xFFE64242); //rgba(230,66,66,1)

const Color titleColor = Color(0xFF787878);//120
const double titleFontSize = 13.0;


class YqBottomSheet {


  //弹出底部文字
  static void showSingleText(
      BuildContext context, {
        @required List<String>? dataArr,
        String? title,
        bool showRedText=false,
        ClickCallback? clickCallback
      }) {

    var titleHeight = cellHeight;
    var titltLineHeight = 1.0;
    if(title==null){
      titleHeight = 0.0;
      titltLineHeight = 0.0;
    }
    var _textColor = textColor;
    if(showRedText){
      _textColor = redTextColor;
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return
            SafeArea(
                child:
                Container(
                  color: Colors.white,
                  height: cellHeight*(dataArr!.length+1)+(dataArr.length-1)*1+spaceHeight+titleHeight+titltLineHeight,
                  child: Column(
                    children: <Widget>[

                      SizedBox(
                          height: titleHeight,
                          child: Center(child: Text(title??"",style: const TextStyle(fontSize: titleFontSize,color: titleColor),textAlign: TextAlign.center))
                      ),
                      SizedBox(height: titltLineHeight,child: Container(color: spaceColor)),

                      ListView.separated(
                        itemCount: dataArr.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return
                            GestureDetector(
                              child:  Container(
                                  height: cellHeight,
                                  color: Colors.white,
                                  child:
                                  Center(
                                      child:Text(dataArr[index],style: TextStyle(fontSize: textFontSize,color: _textColor),textAlign: TextAlign.center)
                                  )
                              ),
                              // onTap: () => Navigator.of(context).pop(index),
                              onTap: (){
                                Navigator.of(context).pop(index);
                                clickCallback!(index,dataArr[index]);
                              },
                            );
                        },

                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            color: spaceColor,
                          );
                        },
                      ),

                      SizedBox(height: spaceHeight,child: Container(color: spaceColor)),
                      GestureDetector(
                        child: Container(
                            height: cellHeight,
                            color: Colors.white,
                            child: const Center(child: Text("取消",style: TextStyle(fontSize: textFontSize,color: textColor),textAlign: TextAlign.center))
                        ),
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                      )

                    ],
                  ),
                )
            );

        }
    );
  }

  ///单选滑动
  static void showSingleSlideText(BuildContext context,{String? str}){
    showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return Container(
            decoration: const BoxDecoration( color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
            padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
            child: Column(
              children:  [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                          height: cellHeight,
                          color: Colors.white,
                          child: const Center(child: Text("取消",style: TextStyle(fontSize: textFontSize,color: Colors.blueAccent),textAlign: TextAlign.left))
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          height: cellHeight,
                          color: Colors.white,
                          child: const Center(child: Text("确认",style: TextStyle(fontSize: textFontSize,color: Colors.blueAccent),textAlign: TextAlign.right))
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                Text('和个人了哦'),
                Text('和个人了哦'),
                Text('和个人了哦'),

              ],
            ),
          );
        },
        backgroundColor: Colors.transparent,//重要
        context: context);
  }

}


