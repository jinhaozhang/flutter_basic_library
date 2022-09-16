
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_library_example/db/demo_model.dart';

/**
  * by zjh
  * 2022/9/8  9:48
  */
class DemoDbPage extends StatefulWidget{

  @override
  _DemoDbPageState createState()=>_DemoDbPageState();

}

class _DemoDbPageState extends State<DemoDbPage>{

  String content='';
  ListModel? updateModel ;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: getPublicAppBar(context, "DB"),
      body: Column(
        children: [
          getPubMaterialButton("增加数据",callback: (){
            ListModel model = ListModel();
            model.createtime =TimeUitls.getTimeStamp();
            model.updatetime = TimeUitls.getTimeStamp();
            model.title = '花见花开';
            // model.desc = 'desc123456';
            add(model);
          }),
          getPubMaterialButton("读取数据",callback: (){
            getList();
          }),
          getPubMaterialButton("更新数据",callback: (){
            update();
          }),
          getPubMaterialButton("删除数据",callback: (){
            delete();
          }),
          getPubMaterialButton("删除全部数据",callback: (){
            deleteAll();
          }),

          Text(content),
        ],
      )
    );
  }

  add(ListModel model)async{
    await DbDataUtils.addData(tableName: ListModelTable.tableName,paramters: model.toMap());

  }

  update()async{
    updateModel!.title='肌肤健康顺利康复';
    await DbDataUtils.updateData(tableName:ListModelTable.tableName,paramters:updateModel!.toMap(), key: ListModelTable.listid,value: updateModel!.listid);
  }

  getList() async{
    content='';
    List<ListModel> list = await DbDataUtils.queryListData<ListModel>(tableName: ListModelTable.tableName,page: 1,selects:ListModelTable.allField,
      key: ListModelTable.uid,values: [1],jsonToBean: (item)=>ListModel.fromJson(item)
    );
    list.forEach((element) {
      content ='$content${element.toJson()}';
    });
    updateModel = list.isNotEmpty?list.first : null;
    setState(() {

    });
  }

  delete() async{
    bool isg = await DbDataUtils.deleteData(tableName:ListModelTable.tableName,key:ListModelTable.listid,value:7);
    print('isg====${isg}');
  }

  deleteAll() async{
    bool isg = await DbDataUtils.deleteAllData(tableName:ListModelTable.tableName);
    print('isg====${isg}');
  }

}

