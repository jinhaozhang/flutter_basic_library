// 当返回的数据是这种格式的时候  {“code”: 0, “message”: “”, “data”: {}}


typedef JsonToBean<T> = T Function(Map<String, dynamic> json);

class BaseEntity<T> {
  int? code;
  String? message;
  T? data;

  BaseEntity({this.code, this.message, this.data});

  factory BaseEntity.fromJson({required Map<String,dynamic> json,required JsonToBean dataBean}) {
    return BaseEntity(
      code: json["code"],
      message: json["msg"],
      // data值需要经过工厂转换为我们传进来的类型
      data:dataBean(json["data"])
    );
  }
}
