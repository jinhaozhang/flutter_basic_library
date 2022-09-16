
import 'package:date_format/date_format.dart';

class TimeUitls {
  //格式化的一些模板
  static final List<String> yyyy_MM_dd = [
    "yyyy",
    "-",
    "mm",
    "-",
    "dd",
  ];
  static final List<String> yyyy_MM_dd2 = [
    "yyyy",
    "年",
    "mm",
    "月",
    "dd",
    "日",
  ];

  static final List<String> yyyy_MM = [
    "yyyy",
    "年",
    "mm",
    "月",
  ];
  static final List<String> yyyy_MM_dd_HH_mm_ss = [
    "yyyy",
    "-",
    "mm",
    "-",
    "dd",
    " ",
    "HH",
    ":",
    "nn",
    ":",
    "ss"
  ];
  static final List<String> yyyy_MM_dd_HH_mm_ss2 = [
    "yyyy",
    "年",
    "mm",
    "月",
    "dd",
    "日",
    " ",
    "HH",
    "时",
    "nn",
    "分",
    "ss",
    "秒"
  ];

  //获取当前时间戳，返回为毫秒
  static int getTimeStamp() {
    return DateTime
        .now()
        .millisecondsSinceEpoch;
  }

  //时间戳转换为日期并格式化
  static String getDateFromStamp(int timeStamp, List<String> formats) {
    return formatDate(getDateTimeFromillisecondsSinceEpoch(timeStamp), formats);
  }

  //时间戳转换为DateTime
  static DateTime getDateTimeFromillisecondsSinceEpoch(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp);
  }

  //当前日期并格式化
  static String getCurrentDate(List<String> formats) {
    return formatDate(DateTime.now(), formats);
  }

  //string类型日期格式化
  static String formatStringDate(String date, List<String> formats) {
    DateTime dateTime = DateTime.parse(date);
    return formatDate(dateTime, formats);
  }

  //日期转时间戳
  static int getTimeStampByStringDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return dateTime.millisecondsSinceEpoch;
  }

  //比较前一个日期是否小于后面的日期
  static bool date1Befordate2(String date1, String date2) {
    int timeStamp1 = getTimeStampByStringDate(date1);
    int timeStamp2 = getTimeStampByStringDate(date2);
    print('${timeStamp1}    $timeStamp2');
    if (timeStamp1 >= timeStamp2) {
      return false;
    } else {
      return true;
    }
  }

  static List<String>  getTimeDate(){
    List<String>  times = ['今日', '昨日', '本周', '上周', '本月', '上月'];
    return times;
  }


  static List getTimeMillisecondsSinceEpoch(String desc,[int? type]){
    List<DateTime> times = [];
    int y = DateTime.now().year;
    int m = DateTime.now().month;
    int d = DateTime.now().day;
    int wd = DateTime.now().weekday;
    switch(desc){
      case '今日':
        times.add(DateTime(y,m,d,0,0,0));
        times.add(DateTime(y,m,d,23,59,59));
        break;
      case '昨日':
        times.add(DateTime(y,m,d-1,0,0,0));
        times.add(DateTime(y,m,d-1,23,59,59));
        break;
      case '本周':
        times.add(DateTime(y,m,d-wd+1,0,0,0));
        times.add(DateTime(y,m,d+(7-wd),23,59,59));
        break;
      case '上周':
        times.add(DateTime(y,m,d-wd-6,0,0,0));
        times.add(DateTime(y,m,d-wd,23,59,59));
        break;
      case '本月':
        times.add(DateTime(y,m,1,0,0,0));
        var dayCount = DateTime(y, m + 1, 0).day;///计算下个月1号的前一天是几号，得出结果
        times.add(DateTime(y,m,dayCount,23,59,59));
        break;
      case '上月':
        times.add(DateTime(y,m-1,1,0,0,0));
        var dayCount = DateTime(y,m, 0).day;///计算本月1号的前一天是几号，得出结果
        times.add(DateTime(y,m-1,dayCount,23,59,59));
        break;
    }
    if(type!=null){
      List timesStr = [];
      if(type==0){
        timesStr.add( formatDate(times[0], yyyy_MM_dd_HH_mm_ss));
        timesStr.add( formatDate(times[1], yyyy_MM_dd_HH_mm_ss));
      }else if(type==1){
        timesStr.add( formatDate(times[0], yyyy_MM_dd));
        timesStr.add( formatDate(times[1], yyyy_MM_dd));
      }else if(type==2){
        timesStr.add(times[0].millisecondsSinceEpoch);
        timesStr.add(times[1].millisecondsSinceEpoch);
      }
      return timesStr;
    }
    return times;
  }
}