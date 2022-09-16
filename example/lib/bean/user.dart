class LoginInfo {
  String? loginName;
  String? pwd;

  LoginInfo({this.loginName, this.pwd});

  LoginInfo.fromJson(Map<String, dynamic> json) {
    loginName = json['loginName'];
    pwd = json['pwd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loginName'] = this.loginName;
    data['pwd'] = this.pwd;
    return data;
  }
}

class UserData {
  String? appToken;
  String? apiToken;
  String? memberClassification;
  String? role;
  String? jxsUserNum;
  String? jxsCode;
  String? isFirstLogin;

  UserData(
      {this.appToken,
        this.memberClassification,
        this.role,
        this.apiToken,
        this.jxsUserNum,
        this.jxsCode,
        this.isFirstLogin});

  UserData.fromJson(Map<String, dynamic> json) {
    appToken = json['appToken'];
    apiToken = json['apiToken'];
    memberClassification = json['memberClassification'];
    role = json['role'];
    jxsUserNum = json['jxsUserNum'];
    jxsCode = json['jxsCode'];
    isFirstLogin = json['isFirstLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appToken'] = this.appToken;
    data['apiToken'] = this.apiToken;
    data['memberClassification'] = this.memberClassification;
    data['role'] = this.role;
    data['jxsUserNum'] = this.jxsUserNum;
    data['jxsCode'] = this.jxsCode;
    data['isFirstLogin'] = this.isFirstLogin;
    return data;
  }
}

class EmployeeBean {
  String? role;
  String? name;
  String? state;
  int? employId;
  int? phone;
  String? areaMessage;
  String? orgCode;
  bool isChecked=false;

  EmployeeBean(
      {this.role,
        this.name,
        this.state,
        this.employId,
        this.phone,
        this.areaMessage,
        this.orgCode, this.isChecked=false});

  EmployeeBean.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    name = json['name'];
    state = json['state'];
    employId = json['employId'];
    phone = json['phone'];
    areaMessage = json['areaMessage'];
    orgCode = json['orgCode'];
    isChecked =false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['name'] = this.name;
    data['state'] = this.state;
    data['employId'] = this.employId;
    data['phone'] = this.phone;
    data['areaMessage'] = this.areaMessage;
    data['orgCode'] = this.orgCode;
    return data;
  }
}
