


import 'package:flutter_basic_library/flutter_basic_library.dart';

class PubType extends BaseSinglePicker{
  String? code;
  String? text;

  PubType({this.code, this.text});

  PubType.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['text'] = this.text;
    return data;
  }

  @override
  String getShwoData() {
    // TODO: implement getShwoData
    return  text!;
  }
}


class RegionDTO {
  String? address;
  String? cityId;
  String? countyId;
  String? provinceId;
  String? townId;

  RegionDTO(
      {this.address, this.cityId, this.countyId, this.provinceId, this.townId});

  RegionDTO.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    cityId = json['cityId'];
    countyId = json['countyId'];
    provinceId = json['provinceId'];
    townId = json['townId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['cityId'] = this.cityId;
    data['countyId'] = this.countyId;
    data['provinceId'] = this.provinceId;
    data['townId'] = this.townId;
    return data;
  }
}

class Pager {
  int? currentPage;
  int? pageNum;
  int? pageSize;
  int? totalPages;
  int? totoalResults;

  Pager(
      {this.currentPage,
        this.pageNum,
        this.pageSize,
        this.totalPages,
        this.totoalResults});

  Pager.fromJson(Map<dynamic, dynamic> json) {
    currentPage = json['currentPage'];
    pageNum = json['pageNum'];
    pageSize = json['pageSize'];
    totalPages = json['totalPages'];
    totoalResults = json['totoalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['pageNum'] = this.pageNum;
    data['pageSize'] = this.pageSize;
    data['totalPages'] = this.totalPages;
    data['totoalResults'] = this.totoalResults;
    return data;
  }
}

class DetailPhoto {
  String? objectKey;
  String? bucketName;
  String? originalURL;

  DetailPhoto(
      {this.objectKey,
        this.bucketName,
        this.originalURL});

  DetailPhoto.fromJson(Map<String, dynamic> json) {
    objectKey = json['objectKey'];
    bucketName = json['bucketName'];
    originalURL = json['originalURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectKey'] = objectKey;
    data['bucketName'] = bucketName;
    data['originalURL'] = originalURL;
    return data;
  }
}

class PhotoBean{
  String? endpoint;
  String? bucket;
  List<String>? photoList;
  List<DetailPhoto>? fileList;

  PhotoBean(
      {this.endpoint,
        this.bucket,
        this.fileList,
        this.photoList});


  PhotoBean.fromJson(Map<String, dynamic> json) {
    endpoint = json['endpoint'];
    bucket = json['bucket'];
    if (json['photoList'] != null) {
      photoList = json['photoList'].cast<String>();
    }
    if (json['fileList'] != null) {
      fileList = <DetailPhoto>[];
      json['fileList'].forEach((v) {
        fileList!.add(DetailPhoto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endpoint'] = endpoint;
    data['bucket'] = bucket;

    if (fileList != null) {
      data['fileList'] =
          fileList!.map((v) => v.toJson()).toList();
    }
    data['photoList'] = photoList;
    return data;
  }
}