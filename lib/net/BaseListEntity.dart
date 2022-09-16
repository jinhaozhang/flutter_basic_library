// 当返回的是这种格式时 {“code”: 0, “message”: “”, “data”: []}

import 'BaseEntity.dart';

class BaseListEntity<T> {
  int? code;
  String? message;
  List<T>? data;

  BaseListEntity({this.code, this.message, this.data});

  factory BaseListEntity.fromJson(json,{required JsonToBean dataBean}) {
    List<T> mData = [];
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['data'] as List).forEach((v) {
        T t = dataBean(v) as T;
        mData.add(t);
      });
    }

    return BaseListEntity(
      code: json["code"],
      message: json["msg"],
      data: mData,
    );
  }
}