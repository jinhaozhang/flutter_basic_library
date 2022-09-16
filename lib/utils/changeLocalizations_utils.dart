// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///创建key值，就是为了调用外部方法
///ChangeLocalizationsState 用来应用内切换语言环境的类
GlobalKey<ChangeLocalizationsState> changeLocalizationStateKey = GlobalKey<ChangeLocalizationsState>();

class LanguageUtils {

  ///使用中文
  static void changeLanguageChina(){
    changeLocalizationStateKey.currentState!.changeLocale(const Locale('zh','CH'));
  }

  ///使用英文
  static void changeLanguageEnglish(){
    changeLocalizationStateKey.currentState!.changeLocale(const Locale('en','US'));
  }
}

class ChangeLocalizations  extends StatefulWidget {
  Widget? child;

  ChangeLocalizations({Key? key, this.child}) : super(key: key);

  @override
  ChangeLocalizationsState createState() => ChangeLocalizationsState();

}

class ChangeLocalizationsState extends State<ChangeLocalizations> {
  //初始是中文
  Locale _locale = const Locale('zh', 'CH');

  changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  //通过Localizations.override 包裹我们需要构建的页面
  @override
  Widget build(BuildContext context) {
    //通过Localizations 实现实时多语言切换
    //通过 Localizations.override 包裹一层。---这里
    return Localizations.override(
      context: context,
      locale: _locale,
      child: widget.child,
    );
  }
}

///自定义多语言处理代理
class MyLocalizationsDelegates
    extends LocalizationsDelegate<ResourcesLocalizations> {
  ///构造
  const MyLocalizationsDelegates();
  ///静态构造
  static MyLocalizationsDelegates delegate = const MyLocalizationsDelegates();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override //是否需要重载
  bool shouldReload(LocalizationsDelegate old) => false;

  ///MyLocalizations就是在此方法内被初始化的
  ///通过方法的 locale 参数，判断需要加载的语言，然后返回自定义好多语言实现类MyLocalizations
  ///最后通过静态 delegate 对外提供 LocalizationsDelegate。
  @override
  Future<ResourcesLocalizations> load(Locale locale) {
    //加载本地化
    return  SynchronousFuture(ResourcesLocalizations(locale));
  }
}

///Localizations类 用于语言资源整合
class ResourcesLocalizations {
  ///该Locale类是用来识别用户的语言环境
  /// 在MyLocalizationsDelegates 的load方法中初始化的
  final Locale locale;

  ResourcesLocalizations(this.locale);


  ///此处通过静态方式来初始化
  static ResourcesLocalizations of(BuildContext context) {
    ///Localizations 是多国语言资源的汇总
    return Localizations.of(context, ResourcesLocalizations);
  }

  //根据不同locale.languageCode 加载不同语言对应
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'task title': 'Flutter Demo',
      'titlebar title': 'Flutter Demo Home Page',
    },
    'zh': {
      'task title': 'Flutter 示例',
      'titlebar title': 'Flutter 示例主页面',
    },
  };

  get taskTitle {
    Map<String, String>? map = _localizedValues[locale.languageCode];
    return map!['task title'];
  }

  get titleBarTitle {
    return _localizedValues[locale.languageCode]!['titlebar title'];
  }
}