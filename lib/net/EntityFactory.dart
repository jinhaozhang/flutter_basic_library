// ignore_for_file: file_names


class EntityFactory{
  static T? generateOBJ<T>(json){
    if(json == null){
      return null;
    }
    // else if(T.toString() == "UserData"){
    //   final res =  UserData.fromJson(json) as T ;
    //   return res ;
    // }
    else{
      return json as T;
    }
  }
}