import 'package:flutter_basic_library/utils/log_utils.dart';
import 'package:rxdart/rxdart.dart';

typedef  OnData = void Function(dynamic event);
class RxUtils{

  static final RxUtils instance = RxUtils._internal();
  factory RxUtils() => instance;
  RxUtils._internal();

  static final Map<String,MyPublishSubject>  subjectMap ={};



  /**
   * 添加观察类型
   */
  void addSubject<T>(String mark,{PublishSubject? publishSubject}){
    PublishSubject subject;
    if(publishSubject!=null){
      subject=publishSubject;
    }else{
      subject=PublishSubject<T>(onListen:(){
        print('PublishSubject  onListen  onListen');
      } ,onCancel: (){
        print('PublishSubject   onCancel   onCancel');
      });
    }
    MyPublishSubject myPublishSubject = MyPublishSubject<T>(subject);
    myPublishSubject.list =[];
    subject.stream.listen((event) {
      subjectMap.forEach((key, value) {
        if(key.compareTo(mark)==0 && value.list.isNotEmpty){
          value.list.forEach((element) {
            element.function.call(event);
          });
        }
      });
    });
    subjectMap[mark]=MyPublishSubject<T>(subject);
  }

  /**
   * 关闭 指定的类型的所有监听
   */
  void remove(String mark){
    subjectMap.removeWhere((key, value){
      if(key.compareTo(mark)==0){
        if(!value.publishSubject.isClosed) value.publishSubject.close();
      }
      return key.compareTo(mark)==0;
    });
  }

  /**
   * 删除指定页面的监听
   */
  void removeSubject(dynamic subject){
    subjectMap.forEach((key, value) {
      value.list.removeWhere((element) => subject==element.subject);
    });
    ///如果已经没有观察者了  就把该类型的删除
    subjectMap.removeWhere((key, value) => value.list.isEmpty);
  }


  /**
   * 添加观察者
   */
  void addListener<T>(dynamic subject,String mark,OnData callBack){
    if(subjectMap.containsKey(mark)){
      subjectMap.forEach((key1, value) {
        if(key1.compareTo(mark)==0){
          bool isHave=false;
          for(int i=0;i<value.list.length;i++){
            if(value.list[i].subject == subject){
              isHave=true;
              break;
            }
          }
          if(!isHave){
            RxdartSubject rxdartSubject = RxdartSubject(subject,callBack);
            value.list.add(rxdartSubject);
          }
        }
      });
    }else{///如果没有该类型的监听  就从新创建  然后加入进去
      addSubject<T>(mark);
      addListener(subject,mark,callBack);
    }
  }

  /**
   * 发射数据
   */
  void shootValue(String mark,dynamic data){
    subjectMap.forEach((key, value) {
      if(key.compareTo(mark)==0){
        try{
          value.publishSubject.add(data);
        } catch(e){
          logUtils(e);
        }
      }
    });
  }

}

class RxdartSubject{
  dynamic subject;
  OnData function;

  RxdartSubject(this.subject,this.function);
  
}

class MyPublishSubject<T>{
  /**
   * PublishSubject 没有添加监听时，add进去的数据  都会被消费调  只会发射出监听之后的数据
   */
  PublishSubject publishSubject;

  /**
   * BehaviorSubject 添加监听后，会将该监听之前最后的add的数据 保存并发射出来  之后add的数据也继续被发射出来
   */
  // BehaviorSubject? _behaviorSubject;

  /**
   * ReplaySubject add之后  会维持一个队列  将add的数据保存起来  添加监听后  一次发射出来  内部的队列时可以指定大小的  超出就会将前面的数据删掉
   */
  // ReplaySubject? _replaySubject;


  List<RxdartSubject> list=[];

  MyPublishSubject(this.publishSubject);
  
}