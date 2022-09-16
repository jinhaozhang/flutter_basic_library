


import 'package:flutter_basic_library/db/sql_utils.dart';

typedef DbJsonToBean<T> = T Function(Map<String, dynamic> json);

class DbDataUtils{

  ///新增数据
  static addData({required String tableName,required Map<String, dynamic> paramters}) async {
    SqlUtils sqlUtils = SqlUtils();
    await sqlUtils.open();
    int state = await sqlUtils.insertByHelper(
        tableName: tableName, paramters: paramters);
    await sqlUtils.close();
    return state > 0 ? true : false;
  }

  ///删除指定数据
  static deleteData({required String tableName,required String key,required dynamic value}) async{
    SqlUtils sqlUtils = SqlUtils();
    await sqlUtils.open();
    int state = await sqlUtils.deleteByHelper(
      tableName: tableName,
      whereStr: "$key = ?",
      whereArgs: [value],
    );
    sqlUtils.close();
    return state > 0 ? true : false;
  }

  ///清空指定表的所有数据
  static deleteAllData({required String tableName})async{
    SqlUtils sqlUtils = SqlUtils();
    await sqlUtils.open();
    int state = await sqlUtils.clear(
        tableName: tableName
    );
    sqlUtils.close();
    print('deleteAllData === $state');
    return state > 0 ? true : false;
  }

  ///更新指定数据的内容
  static updateData({required String tableName,required Map<String, dynamic> paramters ,required String key,required dynamic value}) async{
    SqlUtils sqlUtils = SqlUtils();
    await sqlUtils.open();
    int state = await sqlUtils.updateByHelper(
        tableName: tableName,
        setArgs: paramters,
        whereStr: '$key = ?',
        whereArgs: [value]);
    await sqlUtils.close();
    print('updateData === $state');
    return state > 0 ? true : false;
  }

  ///查询列表数据
  static queryListData<T>({required String tableName,required int page,required List<String> selects,
    required String key,required List<dynamic> values,required DbJsonToBean jsonToBean}) async{
    SqlUtils sqlUtils = SqlUtils();
    List<T> list = [];
    await sqlUtils.open();
    List ulist = await sqlUtils.queryListforpageHelper(
      tableName: tableName,
      selects: selects,
      whereStr: '$key = ?',
      whereArgs: values,
      page: page,
      size: 10,
      // orderBy: "${ListModelTable.updatetime} DESC",
    );
    await sqlUtils.close();
    if (ulist.isNotEmpty) {
      for (var item in ulist) {
        list.add(jsonToBean(item));
      }
    }
    return list;
  }

}