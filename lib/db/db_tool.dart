import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///初始化数据库 创建表结构
class DatabaseUtils {
   Database? _database;

   ///数据库名称
   static String? _dbName;

   ///指定数据库的名称
   static set dbNameValue(String? name) => _dbName=name;

   static get dbName => _dbName ?? 'sql_data.db';

   ///数据库版本
   static int? _dbVersion;

   ///指定数据库的版本
   static set dbVersionValue(int? version) => _dbVersion=version;

   static get dbVersion => _dbVersion ?? 1;

   ///数据库升级时的  每个版本的sql语句
   static Map<int,List<String>>? versionSqls;

  //饿汉式单例
  static final DatabaseUtils _instance = DatabaseUtils._();

  //工厂模式，单例公开访问点
  factory DatabaseUtils() => _getInstance();

  //私有构造
  DatabaseUtils._();

  static DatabaseUtils _getInstance() {
    return _instance;
  }

   /**
    * tables 创建所有的表信息  可仿照TablesConfig
    * name  数据库的名称
    * version 数据库的版本升级
    * versionSql  每个数据库版本升级对应的sql语句
    *
    * 初始化数据库的实例例子
    * await DatabaseUtils().init(tables: TablesConfig.getAllTables(),versionSql: TablesConfig.version_sqls);
    *
    */
  Future init({required  Map<String, String> tables,String? name,int? version,Map<int,List<String>>? versionSql}) async {
    dbNameValue=name;
    dbVersionValue=version;
    versionSqls = versionSql;
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    print('db path is============ $path');
    try {
      _database = await openDatabase(path);
    } catch (e) {
      print('CreateTables init Error $e');
    }
    //检查需要生成的表
    List<String> noCreateTables = await getNoCreateTables(tables);
    print('noCreateTables:' + noCreateTables.toString());
      //创建新表
      // 关闭上面打开的db，否则无法执行open
      _database!.close();
      _database = await openDatabase(path, version:dbVersion,
          onCreate: (Database db, int version) async {
            print('db created version is============ $version');
          }, onOpen: (Database db) async {
            if (noCreateTables.isNotEmpty){
              for (var sql in noCreateTables) {
                await db.execute(tables[sql]!);
              }
            }
            print('db补完表已打开');
          },onUpgrade: upgrade,onDowngrade: onDowngrade);

    List tableMaps = await _database!
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    print('所有表:' + tableMaps.toString());
    _database!.close();
    print("db已关闭");
  }

  //升级表结构 如果有新字段加入比如这里的sex ，则旧的表需要升级表结构
   upgrade(Database db, int oldVersion, int newVersion) async{
    Batch batch = db.batch();
    if(versionSqls!.containsKey(oldVersion)){
      List<String>?  sqls = versionSqls![oldVersion];
      for (var element in sqls!) {
        batch.execute(element);
      }
    }
    oldVersion++;
    //升级后版本还低于当前版本，继续递归升级
    if (oldVersion < newVersion) {
      upgrade(db, oldVersion, newVersion);
    }
    await batch.commit();
  }

  // 检查数据库中是否有所有有表,返回需要创建的表
  Future<List<String>> getNoCreateTables(Map<String, String> tableSqls) async {
    Iterable<String> tableNames = tableSqls.keys;
    //已经存在的表
    List<String> existingTables = [];
    //要创建的表
    List<String> createTables = [];
    List tableMaps = await _database!
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    print('tableMaps:' + tableMaps.toString());
    for (var item in tableMaps) {
      existingTables.add(item['name']);
    }
    for (var tableName in tableNames) {
      if (!existingTables.contains(tableName)) {
        createTables.add(tableName);
      }
    }
    return createTables;
  }

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    await batch.commit();
  }

}