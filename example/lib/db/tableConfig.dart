import 'package:flutter_basic_library/db/sql_config.dart';

import 'demo_model.dart';

///配置所有表的sql语句
///${ListModelTable.desc} ${SqlConfig.sqltext},
class TablesDemoConfig {
  static final String createListTable = '''
    ${SqlConfig.creatTable} ${ListModelTable.tableName} (
    ${ListModelTable.listid} ${SqlConfig.primarykeyauto},
    ${ListModelTable.uid} BIGINT(20),
    ${ListModelTable.name} ${SqlConfig.sqltext},
    ${ListModelTable.title} ${SqlConfig.sqltext},
    ${ListModelTable.createtime} BIGINT(20),
    ${ListModelTable.updatetime} BIGINT(20)
    )
    ''';
  static final String createList2Table = '''
    ${SqlConfig.creatTable} ${List2ModelTable.tableName} (
    ${List2ModelTable.listid} ${SqlConfig.primarykeyauto},
    ${List2ModelTable.uid} BIGINT(20),
    ${List2ModelTable.name} ${SqlConfig.sqltext},
    ${List2ModelTable.title} ${SqlConfig.sqltext},
    ${List2ModelTable.createtime} BIGINT(20),
    ${List2ModelTable.updatetime} BIGINT(20)
    )
    ''';

  /// 获取所有的表   表名  创建表的语句
  static Map<String, String> getAllTables() {
    Map<String, String> map = <String, String>{};
    map[ListModelTable.tableName] = createListTable;
    map[List2ModelTable.tableName] = createList2Table;
    print('map===$map');
    return map;
  }

  /**
   * DROP TABLE table_name; 删除表
   */
  static List<String> get version_1_2 => [
    // '''alter table ${ListModelTable.tableName} add column ${ListModelTable.desc} ${SqlConfig.sqltext}''',///增加文本类型desc  更新测试
    // '''alter table ${ListModelTable.tableName} add column age not null default 0''',///增加age  不能为空 默认值为0
    // createList2Table///增加表
  ];

  static List<String> get version_2_3 => [
    // '''alter table ${ListModelTable.tableName} delete column desc''',///删除该列desc
  ];

}