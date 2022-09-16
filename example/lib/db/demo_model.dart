import 'dart:convert';


abstract class DbTableBean{

  String get tableName;

}

class ListModelTable {

  static String tableName = "list";

  static String uid = "uid";
  static String listid = 'listid';
  static String name = "name";
  static String title = 'title';
  static String createtime = 'createtime';
  static String updatetime = 'updatetitme';

  // static String desc = 'desc';///测试数据库更新的字段

  // static List<String> get allField =>[uid,listid,name,title,createtime,updatetime,desc];
  static List<String> get allField =>[uid,listid,name,title,createtime,updatetime];

}


class ListModel {
  ListModel({
    this.uid,
    this.listid,
    this.title,
    this.createtime,
    this.updatetime,
  });

  /// 用户ID
  int? uid;

  int? listid;

  /// 标题
  String? title;

  /// 标题
  // String? desc;

  /// 创建时间
  int? createtime;

  /// 更新时间
  int? updatetime;

  String toJson() => json.encode(toMap());

  ListModel.fromJson(Map<String, dynamic> json) {
    uid = json[ListModelTable.uid];
    listid = json[ListModelTable.listid];
    title = json[ListModelTable.title];
    // desc = json[ListModelTable.desc];
    createtime = json[ListModelTable.createtime];
    updatetime = json[ListModelTable.updatetime];
  }

  Map<String, dynamic> toMap() => {
    ListModelTable.uid: 1,
    ListModelTable.listid: listid,
    ListModelTable.createtime: createtime,
    ListModelTable.updatetime: updatetime,
    ListModelTable.title: title,
    // ListModelTable.desc: desc,
  };
}


class List2ModelTable {

  static String tableName = "list2";

  static String uid = "uid";
  static String listid = 'listid';
  static String name = "name";
  static String title = 'title';
  static String createtime = 'createtime';
  static String updatetime = 'updatetitme';
}


class ListModel2 {
  ListModel2({
    this.uid,
    this.listid,
    this.title,
    this.createtime,
    this.updatetime,
  });

  /// 用户ID
  int? uid;

  int? listid;

  /// 标题
  String? title;

  /// 创建时间
  int? createtime;

  /// 更新时间
  int? updatetime;

  // factory ListModel2.fromJson(String str) => ListModel2.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  ListModel2.fromJson(Map<String, dynamic> json) {
    uid = json[ListModelTable.uid];
    listid = json[ListModelTable.listid];
    title = json[ListModelTable.title];
    createtime = json[ListModelTable.createtime];
    updatetime = json[ListModelTable.updatetime];
  }

  Map<String, dynamic> toMap() => {
    List2ModelTable.uid: 1,
    List2ModelTable.listid: listid,
    List2ModelTable.createtime: createtime,
    List2ModelTable.updatetime: updatetime,
    List2ModelTable.title: title,
  };
}