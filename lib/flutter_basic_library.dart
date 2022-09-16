library flutter_basic_library;


///数据库相关
export 'package:flutter_basic_library/db/db_data_utls.dart';
export 'package:flutter_basic_library/db/db_tool.dart';

///文件相关
export 'package:flutter_basic_library/utils/file_utils.dart';

///SpUtils相关
export 'package:flutter_basic_library/utils/shared_preferences_utils.dart';

///EventBusUtils
export 'package:flutter_basic_library/utils/eventbus_utils.dart';

///时间工具类
export 'package:flutter_basic_library/utils/time_utils.dart';

///导航处理
export 'package:flutter_basic_library/utils/navigator_util.dart';

///阿里的log日志信息
export 'package:flutter_basic_library/utils/ali_emas_log.dart';

///金钱的工具类
export 'package:flutter_basic_library/utils/money_utils.dart';

///rxdart的工具类
export 'package:flutter_basic_library/utils/rxdart_utils.dart';

///添加log的输出工具  logUtils
export 'package:flutter_basic_library/utils/log_utils.dart';

///屏幕适配
export 'package:flutter_basic_library/utils/size_extension.dart';
export 'package:flutter_basic_library/utils/YQScreenSizeUtils.dart';

///Widget的公共拓展方法
export 'package:flutter_basic_library/utils/widget_padding.dart';

///常用的的公共组件方法
export 'package:flutter_basic_library/utils/widget_utils.dart';

///网络dio相关的
export 'package:flutter_basic_library/net/NetUtils.dart';
export 'package:flutter_basic_library/net/NetMethod.dart';
export 'package:flutter_basic_library/net/net_interceptors_wrapper.dart';
export 'package:flutter_basic_library/net/down_up_load_bean.dart';

///与原生app的沟通桥梁
export 'package:flutter_basic_library/utils/channel_util.dart';
export 'package:flutter_basic_library/utils/common_method_channel.dart';

///pull_to_refresh的配置相关
export 'package:flutter_basic_library/refresh/refreshConfiguration_widget.dart';
export 'package:flutter_basic_library/refresh/refresher_footer.dart';
export 'package:flutter_basic_library/refresh/refresher_header.dart';

///常用公共组件
export 'package:flutter_basic_library/widget/popuwindow_widget.dart';
export 'package:flutter_basic_library/widget/list_widget.dart';
export 'package:flutter_basic_library/widget/two_level_list_widget.dart';
export 'package:flutter_basic_library/widget/level_vertical_scorll_table_widget.dart';
export 'package:flutter_basic_library/widget/sing_picker_utils.dart';
export 'package:flutter_basic_library/widget/double_date_widget.dart';
export 'package:flutter_basic_library/widget/search_widget.dart';
export 'package:flutter_basic_library/widget/imge_wiget.dart';
export 'package:flutter_basic_library/widget/appbar_search_widget.dart';
export 'package:flutter_basic_library/base/base_list.dart';
export 'package:flutter_basic_library/base/base_state.dart';
export 'package:flutter_basic_library/base/base_tab_state.dart';
export 'package:flutter_basic_library/utils/indicator_style.dart';
export 'package:flutter_basic_library/mvp/mvp_base.dart';
export 'package:flutter_basic_library/mvvm/mvvm_base.dart';
export 'package:flutter_basic_library/widget/material_app_widget.dart';


import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBasicLibrary {
  static const MethodChannel _channel = MethodChannel('flutter_basic_library');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
