
import 'package:flutter/material.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:rxdart/rxdart.dart';


/**
  * by zjh
  * 2022/9/15  14:35
  */
class RxdartDemoPage extends StatefulWidget{

  @override
  _RxdartDemoPageState createState()=>_RxdartDemoPageState();

}


class _RxdartDemoPageState extends State<RxdartDemoPage>{

  /**
   * PublishSubject 没有添加监听时，add进去的数据  都会被消费调  只会发射出监听之后的数据
   */
  // PublishSubject? subject;

  /**
   * BehaviorSubject 添加监听后，会将该监听之前最后的add的数据 保存并发射出来  之后add的数据也继续被发射出来
   */
  BehaviorSubject? _behaviorSubject;

  /**
   * ReplaySubject add之后  会维持一个队列  将add的数据保存起来  添加监听后  一次发射出来  内部的队列时可以指定大小的  超出就会将前面的数据删掉
   */
  ReplaySubject? _replaySubject;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // subject = PublishSubject<int>(onListen:(){
    //   print('PublishSubject  onListen  onListen');
    // } ,onCancel: (){
    //   print('PublishSubject   onCancel   onCancel');
    // });

    _behaviorSubject = BehaviorSubject<int>(onListen:(){
      print('BehaviorSubject  onListen  onListen');
    } ,onCancel: (){
      print('BehaviorSubject   onCancel   onCancel');
    });

    _replaySubject = ReplaySubject<int>(onListen:(){
      print('ReplaySubject  onListen  onListen');
    } ,onCancel: (){
      print('ReplaySubject   onCancel   onCancel');
    },maxSize: 2);


    // subject!.map((event) => event>2).listen((event) {
    //   print('subject.event====================$event');
    // });
    RxUtils.instance.addListener<int>(this,'demo',(value){
      print('RxdartUtils.event====================$value');
    });

    _behaviorSubject!.stream.listen((event) {
      print('_behaviorSubject.event====================$event');
    });

    _replaySubject!.stream.listen((event) {
      print('_replaySubject.event====================$event');
    });

    Rx.range(1, 10).listen((event) {
      print('Rx.event====================$event');
    },onDone: (){
      print('Rx.event====================onDone');
    });
    Rx.timer(456, Duration(seconds: 5)).listen((event) {
      print('Rx.timer====================$event');
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: getPublicAppBar(context, 'RxdartDemoPage'),
      body: Column(
        children: [
          Text('111111111111111111111').click(() {
            // subject!.add(1);
            RxUtils.instance.shootValue('demo',1);
            _replaySubject!.add(1);
            _behaviorSubject!.add(1);
          }),
          Text('2222222222222222').click(() {
            // subject!.add(2);
            RxUtils.instance.shootValue('demo',2);
            _replaySubject!.add(2);
            _behaviorSubject!.add(2);
          }),
          Text('3333333333333').click(() {
            // subject!.add(3);
            RxUtils.instance.shootValue('demo',3);
            _replaySubject!.add(3);
            _behaviorSubject!.add(3);
          }),
        ],
      ),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    RxUtils.instance.removeSubject(this);
    // subject!.close();
    _replaySubject!.close();
    _behaviorSubject!.close();
  }

}

