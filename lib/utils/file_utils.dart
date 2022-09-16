import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

///记得初始化目录路径
class FilesUtils2{

  static String cache_name='/cache.txt';

  static String cache_directory='';

  static void init(){
    getTempDir().then((value){
      cache_directory=value!;
    });
  }

  /**
   * 创建文件夹
   */
  static Future directoryCreate(String name) async {
    var directory = Directory(name);
    directory.create();
  }

  /**
   * 列出指定目录的所有文件
   */
  static List<String> listFiles(String path){
    ///sdcard
    List<String> paths = [];
    var systemTempDir = Directory(path);
    systemTempDir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      paths.add(entity.path);
    });
    return paths;
  }


  /**
   * 是否有此目录
   */
  static isDirectory(String path){
    var isHave=false;
    var directory = Directory(path);
    directory.exists().then((value) => isHave=value);
    return isHave;
  }

  /**
   * 文件夹重命名
   */
  static void renameDirectory(String oldName,String newName){
    var directory = Directory(oldName);
    directory.rename(newName).then((Directory directory) {});
  }

  /**
   * 创建文件
   * 文件的全路径加文件名称
   */
  static Future<File> createFile(String path){
    var file = File(path);
    return file.create();
  }

  /**
   * 文件是否存在
   * 文件的全路径加文件名称
   */
  static isFile(String path){
    var isHave=false;
    var directory = File(path);
    directory.exists().then((value) => isHave=value);
    return isHave;
  }

  // FileMode.read 只读
  // FileMode.write 可读可写，如果文件存在覆盖，如果文件不存在创建
  // FileMode.append 可读可写，如果文件存在在末尾追加，如果文件不存在创建
  // FileMode.writeOnly 只写，如果文件存在覆盖，如果文件不存在创建
  // FileModel.writeOnlyAppend 只写，如果文件存在在末尾追加，如果文件不存在创建
  /**
   * 文件写入
   */
  static  Future<File> writeString(String data,{String? filePath,FileMode? mode}) async{
    // final file=File(filePath ?? cache_name);
    final file=File('$cache_directory${filePath ?? cache_name}');
    return file.writeAsString(data,mode: mode!);
  }

  /// 写入json文件
  static Future<File?> writeJsonFile(obj, {String? filePath,FileMode? mode}) async {
    try {
      // final file = File(filePath);
      final file=File('$cache_directory${filePath ?? cache_name}');
      return await file.writeAsString(json.encode(obj),mode: mode!);
    } catch (err) {
      print(err);
      return null;
    }
  }

  /// 读取json文件
  static Future<String?> readFile({String? filePath}) async {
    try {
      // final file = File(filePath ?? cache_name);
      final file=File('$cache_directory${filePath ?? cache_name}');
      return await file.readAsString();
    } catch (err) {
      print(err);
      return null;
    }
  }


 ///相当于Android上的getCacheDir和IOS上的NSCachesDirectory
  /// 临时目录: /data/user/0/com.flutter.module.flutter_module.host/cache
  /// 一个临时目录(缓存)，系统可以随时清除。
  static Future<String?> getTempDir() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      return tempDir.path;
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///相当于Android上的getDataDirectory和IOS上的NSDocumentDirectory
  /// 文档目录:  /data/user/0/com.flutter.module.flutter_module.host/app_flutter
  /// 应用程序的目录，用于存储只有它可以访问的文件。只有当应用程序被删除时，系统才会清除目录。
  static Future<String?> getAppDocDir() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      return appDocDir.path;
    } catch (err) {
      print(err);
      return null;
    }
  }


  ///android ios 都可用  /data/user/0/com.flutter.module.flutter_module.host/files
  // static Future<Directory> getAppSupportDir() => getApplicationSupportDirectory();

  ///android 专有  /storage/emulated/0/Android/data/com.flutter.module.flutter_module.host/cache
  // static Future<List<Directory>> getAndroidExternalCacheDir() => getExternalCacheDirectories();

  ///android 专有  /storage/emulated/0/Android/data/com.flutter.module.flutter_module.host/files
  // static Future<Directory> getAndroidExternalDir() => getExternalStorageDirectory();

  ///android 专有  /storage/emulated/0/Android/data/com.flutter.module.flutter_module.host/files
  // static Future<List<Directory>> getAndroidExternalStorageDir() => getExternalStorageDirectories();

  // static Future<Directory> getDownloadsDir() => getDownloadsDirectory();

}