
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

///网络请求的公共参数
class PublicParameter{
  static String? _net_typeDesc="NONE";
  static String? _app_nameDesc="NONE";
  static String? _package_nameDesc="NONE";
  static String? _app_versionDesc="NONE";
  static String? _build_numberDesc="NONE";
  static String? _build_signatureDesc="NONE";
  static String? _deviceModelDesc="NONE";
  static String? _deviceIdDesc="NONE";
  static String? _osVersionDesc="NONE";

  static get net_type=> _net_typeDesc ?? 'NONE';
  static set net_typeValue(String? value) =>_net_typeDesc=value;

  static get app_name=> _app_nameDesc ?? 'NONE';
  static set app_nameValue(String? value) =>_app_nameDesc=value;

  static get package_name=> _package_nameDesc ?? 'NONE';
  static set npackage_nameValue(String? value) =>_package_nameDesc=value;

  static get app_version=> _app_versionDesc ?? 'NONE';
  static set app_versionValue(String? value) =>_app_versionDesc=value;

  static get build_number=> _build_numberDesc ?? 'NONE';
  static set build_numberValue(String? value) =>_build_numberDesc=value;

  static get build_signature=> _build_signatureDesc ?? 'NONE';
  static set build_signatureValue(String? value) =>_build_signatureDesc=value;

  static get deviceModel=> _deviceModelDesc ?? 'NONE';
  static set deviceModelValue(String? value) =>_deviceModelDesc=value;

  static get deviceId=> _deviceIdDesc ?? 'NONE';
  static set deviceIdValue(String? value) =>_deviceIdDesc=value;

  static get osVersion=> _osVersionDesc ?? 'NONE';
  static set osVersionValue(String? value) =>_osVersionDesc=value;



}

class Proxy{

  static String? PROXY_IP;///代理IP

}

class PrimaryDomainName{

  static String? _app_tokenDesc;

  static get app_token =>_app_tokenDesc;

  static set app_tokenValue(String? value)=> _app_tokenDesc=value;

  static String? _base_urlDesc;

  static get base_url =>_base_urlDesc ?? 'https://qaapi.yqfoodec.com';

  static set base_urlValue(String? value)=> _base_urlDesc=value;


}

///多域名的配置
class DomainOne{

  static String? _api_tokenDesc;

  static get api_token =>_api_tokenDesc;

  static set api_tokenValue(String value)=> _api_tokenDesc=value;

  static String? _baseApiDesc;

  static get baseApi =>_baseApiDesc ?? 'https://qa-nirvana.yqfoodec.com';

  static set baseApiValue(String value)=> _baseApiDesc=value;

  static const ORDER_DELIVERY_RECORD = "ORDER_DELIVERY_RECORD";

  static const Map<String,String> urlMap ={
    ORDER_DELIVERY_RECORD:"/yqxd/api/v1/order/send/record",
  };


}